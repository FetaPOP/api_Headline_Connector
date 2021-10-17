# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/rg'
require 'yaml'
require_relative '../lib/yt_api'
# need to change

VIDEO_ID = 'cmSbXsFE3l8'
#need to change to id
CONFIG = YAML.safe_load(File.read('config/secrets.yml'))
YOUTUBE_TOKEN = CONFIG['YOUTUBE_TOKEN']
CORRECT = YAML.safe_load(File.read('spec/fixtures/youtube_results.yml'))
#Have to wait until know the strucutre of the .yaml file

describe 'Tests Youtube API library' do

  before do
    @content = HeadlineConnector::YoutubeApi.new(YOUTUBE_TOKEN)
    @data = @content.data_collect(VIDEO_ID)
  end

  describe 'Video information' do
    it 'HAPPY: should provide correct video information' do
      video = @content.video(@data)
      _(video.id).must_equal CORRECT['id']
      _(video.title).must_equal CORRECT['title']
      _(video.description).must_equal CORRECT['description']
      _(video.tags).must_equal CORRECT['tags']
      _(video.channel).must_equal CORRECT['channel']
    end

    it 'SAD: should return an empty list of items due to non-existing video ID' do
      wrong_id = "ThisIdIsNotAValidId"
      response = HeadlineConnector::YoutubeApi.new(YOUTUBE_TOKEN).data_collect('wrong_id')
      _(response['items']).must_be_empty
    end  

    it 'SAD: should raise a BAD_TOKEN exception' do
      _(proc do
        wrong_token = "ThisToKenIsNotAValidToken"
        HeadlineConnector::YoutubeApi.new(wrong_token).data_collect('wrongid_haha')
      end).must_raise HeadlineConnector::YoutubeApi::Errors::BAD_TOKEN
    end
  end

  describe 'Channel information' do
    it 'HAPPY: should provide correct channel information' do
        channel = @content.channel(@data)
        _(channel.channelId).must_equal CORRECT['channelId']
        _(channel.channelTitle).must_equal CORRECT['channelTitle']
      end
  end
end