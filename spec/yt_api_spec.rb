# frozen_string_literal: true

require_relative 'spec_helper'

describe 'Tests Youtube API library' do
  VCR.configure do |c|
    c.cassette_library_dir = CASSETTES_FOLDER
    c.hook_into :webmock

    c.filter_sensitive_data('<YOUTUBE_TOKEN>') { YOUTUBE_TOKEN }
    c.filter_sensitive_data('<YOUTUBE_TOKEN_ESC>') { CGI.escape(YOUTUBE_TOKEN) }
  end

  before do
    VCR.insert_cassette CASSETTE_FILE,
                        record: :new_episodes,
                        match_requests_on: %i[method uri headers]
  end

  after do
    VCR.eject_cassette
  end

  describe 'Feed information' do
    it 'HAPPY: should provide correct feed information' do
      data = HeadlineConnector::YoutubeApi.new(YOUTUBE_TOKEN).collect_data(VIDEO_ID)
      feed = HeadlineConnector::Feed.new(data)
      _(feed.id).must_equal CORRECT['id']
      _(feed.title).must_equal CORRECT['title']
      _(feed.description).must_equal CORRECT['description']
      _(feed.tags).must_equal CORRECT['tags']
      _(feed.provider).must_equal CORRECT['provider']
    end

    it 'SAD: should return an empty list of items due to non-existing feed ID' do
      wrong_id = 'ThisIdIsNotAValidId'
      data = HeadlineConnector::YoutubeApi.new(YOUTUBE_TOKEN).collect_data(wrong_id)
      _(data['items']).must_be_empty
    end

    it 'SAD: should raise a BadToken exception' do
      _(proc do
        wrong_token = 'ThisToKenIsNotAValidToken'
        HeadlineConnector::YoutubeApi.new(wrong_token).collect_data(VIDEO_ID)
      end).must_raise HeadlineConnector::YoutubeApi::Errors::BadToken
    end
  end

  describe 'Provider information' do
    it 'HAPPY: should provide correct provider information' do
      data = HeadlineConnector::YoutubeApi.new(YOUTUBE_TOKEN).collect_data(VIDEO_ID)
      provider = HeadlineConnector::Provider.new(data)
      _(provider.id).must_equal CORRECT['channelId']
      _(provider.title).must_equal CORRECT['channelTitle']
    end
  end

end
