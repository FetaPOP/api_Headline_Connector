# frozen_string_literal: true

require_relative '../../../helpers/spec_helper.rb'
require_relative '../../../helpers/vcr_helper.rb'
require_relative '../../../helpers/database_helper.rb'

describe 'AddTopic Service Integration Test' do
  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_youtube(recording: :none)
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Retrieve and store topic' do
    before do
      DatabaseHelper.wipe_database
    end

    it 'HAPPY: should be able to find and save topic to database' do
      # GIVEN: a valid keyword request for a search result list of youtube videos:
      topic_entity = HeadlineConnector::Youtube::TopicMapper.new(YOUTUBE_TOKEN).search_keyword(TOPIC_NAME)

      # WHEN: the service is called with the request form object
      topic_entity_result = HeadlineConnector::Service::AddTopic.new.call(
        requested: HeadlineConnector::Request::TopicRequest.new(TOPIC_NAME, nil)
      )

      # THEN: the result should report success.
      _(topic_entity_result.success?).must_equal true

      # ..and provide a topic entity with the right details
      rebuilt_topic_entity = topic_entity_result.value!.message
      
      _(rebuilt_topic_entity.related_videos_ids.length()).must_equal topic_entity.related_videos_ids.length()
      
    end

    it 'HAPPY: should find and return existing project in database' do
      # GIVEN: a valid keyword request for a topic already in the database:
      first_rebuilt_topic_entity = HeadlineConnector::Service::AddTopic.new.call(
        requested: HeadlineConnector::Request::TopicRequest.new(TOPIC_NAME, nil)
      ).value!.message

      # WHEN: the service is called with the request form object
      topic_entity_result = HeadlineConnector::Service::AddTopic.new.call(
        requested: HeadlineConnector::Request::TopicRequest.new(TOPIC_NAME, nil)
      )

      # THEN: the result should report success..
      _(topic_entity_result.success?).must_equal true

      # ..and provide a project entity with the right details
      second_rebuilt_topic_entity = topic_entity_result.value!.message
      _(first_rebuilt_topic_entity.related_videos_ids.length()).must_equal second_rebuilt_topic_entity.related_videos_ids.length()
      
      first_rebuilt_topic_entity.related_videos_ids.each do |video_id|
        _(second_rebuilt_topic_entity.related_videos_ids.include? video_id).must_equal true
      end
    end

  end
end
