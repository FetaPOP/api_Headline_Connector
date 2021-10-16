# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/rg'
require 'yaml'
require_relative '../lib/youtube_api'
# need to change

VIDEO_ID = 'YPBT-app'
#need to change to id
CONFIG = YAML.safe_load(File.read('config/secrets.yml'))
YOUTUBE_TOKEN = CONFIG['YOUTUBE_TOKEN']
CORRECT = YAML.safe_load(File.read('spec/fixtures/youtube_results.yml'))

describe 'Tests Youtube API library' do
  describe 'Video information' do
    it 'HAPPY: should provide correct video information' do
      video = HeadlineConnector::YoutubeApi.new(YOUTUBE_TOKEN)
                                     .video(VIDEO_ID)
      _(video.id).must_equal CORRECT['id']
      _(video.title).must_equal CORRECT['title']
      _(video.description).must_equal CORRECT['description']
      _(video.tags).must_equal CORRECT['tags']
      _(video.channel).must_equal CORRECT['channel']
    end

    it 'SAD: should raise exception on incorrect video' do
      _(proc do
        HeadlineConnector::YoutubeApi.new(YOUTUBE_TOKEN).video('wrongid-haha')
      end).must_raise HeadlineConnector::YoutubeApi::Errors::NotFound
    end
    # For youtube, id has 11 char, while the incorrect video id above is with 12 char

    it 'SAD: should raise exception when unauthorized' do
      _(proc do
        HeadlineConnector::YoutubeApi.new('BAD_TOKEN').video('wrongid-haha')
      end).must_raise HeadlineConnector::YoutubeApi::Errors::Unauthorized
    end
  end

  describe 'Channel information' do
    before do
      @video = HeadlineConnector::YoutubeApi.new(YOUTUBE_TOKEN)
                                      .video(VIDEO_ID, video_NAME)
    end

    it 'HAPPY: should recognize owner' do
      _(@video.owner).must_be_kind_of HeadlineConnector::Channel
    end

    it 'HAPPY: should identify owner' do
      _(@video.owner.username).wont_be_nil
      _(@video.owner.username).must_equal CORRECT['owner']['login']
    end

    it 'HAPPY: should identify contributors' do
      contributors = @video.contributors
      _(contributors.count).must_equal CORRECT['contributors'].count

      usernames = contributors.map(&:username)
      correct_usernames = CORRECT['contributors'].map { |c| c['login'] }
      _(usernames).must_equal correct_usernames
    end
  end
end