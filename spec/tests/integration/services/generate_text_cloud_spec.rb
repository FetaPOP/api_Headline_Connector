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

  describe 'Generate a Text Cloud' do
    before do
      DatabaseHelper.wipe_database
    end

    it 'HAPPY: should generate a textcloud for an existing topic' do
      # GIVEN: a valid topic that exists locally and is being watched
      yt_topic = HeadlineConnector::Youtube::FeedMapper.new(App.config.YOUTUBE_TOKEN).request_video(video_id)
      Repository::For.entity(yt_topic).create(yt_topic)

      # WHEN: we request to generate a text cloud
      keyword = TOPIC_NAME

      result = HeadlineConnector::Service::GenerateTextCloud.new.call(
        watched_list: [keyword],
        keyword: keyword
      ).value!

      # THEN: we should get a text cloud
      text_cloud = result[:textcloud]
      _(text_cloud).must_be_kind_of HeadlineConnector::Entity::TextCloud

    end

    it 'SAD: should not generate a textcloud for an unwatched topic' do
      # GIVEN: a valid topic that exists locally and is being watched
      yt_topic = HeadlineConnector::Youtube::FeedMapper.new(App.config.YOUTUBE_TOKEN).request_video(video_id)
      Repository::For.entity(yt_topic).create(yt_topic)

      # WHEN: we request to generate a text cloud
      keyword = TOPIC_NAME

      result = HeadlineConnector::Service::GenerateTextCloud.new.call(
        watched_list: [],
        keyword: keyword
      )

      # THEN: we should get failure
      _(result.failure?).must_equal true
    end

    it 'SAD: should not generate a textcloud for a non-existent topic' do
      # GIVEN: no topic exists locally

      # WHEN: we request to generate a text cloud
      keyword = TOPIC_NAME

      result = HeadlineConnector::Service::GenerateTextCloud.new.call(
        watched_list: [],
        keyword: keyword
      )

      # THEN: we should get failure
      _(result.failure?).must_equal true
    end
  end
end
