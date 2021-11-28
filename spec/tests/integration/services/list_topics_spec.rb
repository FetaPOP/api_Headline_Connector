# frozen_string_literal: true

require_relative '../../../helpers/spec_helper.rb'
require_relative '../../../helpers/vcr_helper.rb'
require_relative '../../../helpers/database_helper.rb'

require 'ostruct'

describe 'GenerateTextCloud Service Integration Test' do
  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_youtube(recording: :none)
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Generate Text Cloud' do
    before do
      DatabaseHelper.wipe_database
    end

    it 'HAPPY: should return topics that are being watched' do
      # GIVEN: a valid topic exists locally and is being watched
      yt_topic = HeadlineConnector::Youtube::FeedMapper
        .new(App.config.YOUTUBE_TOKEN)
        .request_video(video_id)
      db_topic = HeadlineConnector::Repository::For.entity(yt_topic)
        .create(yt_topic)

      watched_list = [video_id]

      # WHEN: we request a list of all watched topics
      result = HeadlineConnector::Service::ListTopics.new.call(watched_list)

      # THEN: we should see our project in the resulting list
      _(result.success?).must_equal true
      topics = result.value!
      _(topic).must_include db_topic
    end

    it 'HAPPY: should not return topics that are not being watched' do
      # GIVEN: a valid topic exists locally but is not being watched
      yt_topic = HeadlineConnector::Youtube::FeedMapper
        .new(App.config.YOUTUBE_TOKEN)
        .request_video(video_id)
      HeadlineConnector::Repository::For.entity(yt_topic)
        .create(yt_topic)

      watched_list = []

      # WHEN: we request a list of all watched topics
      result = HeadlineConnector::Service::ListTopics.new.call(watched_list)

      # THEN: it should return an empty list
      _(result.success?).must_equal true
      topics = result.value!
      _(topics).must_equal []
    end

    it 'SAD: should not watched topics if they are not loaded' do
      # GIVEN: we are watching a project that does not exist locally
      watched_list = [video_id]

      # WHEN: we request a list of all watched topics
      result = HeadlineConnector::Service::ListTopics.new.call(watched_list)

      # THEN: it should return an empty list
      _(result.success?).must_equal true
      topics = result.value!
      _(topics).must_equal []
    end
  end
end
