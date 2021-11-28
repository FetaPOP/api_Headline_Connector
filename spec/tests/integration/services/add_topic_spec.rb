# frozen_string_literal: true

require_relative '../../../helpers/spec_helper.rb'
require_relative '../../../helpers/vcr_helper.rb'
require_relative '../../../helpers/database_helper.rb'

describe 'GenerateTextCloud Service Integration Test' do
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
      topic = HeadlineConnector::Youtube::TopicMapper.new(App.config.YOUTUBE_TOKEN).search_keyword(TOPIC_NAME)
      keyword = HeadlineConnector::Forms::NewTopic.new.call(keyword: TOPIC_NAME)

      # WHEN: the service is called with the request form object
      topic_made = HeadlineConnector::Service::AddTopic.new.call(keyword)

      # THEN: the result should report success..
      _(topic_made.success?).must_equal true

      # ..and provide a topic entity with the right details
      rebuilt = topic_made.value!

      topic.related_videos_ids.each do |vid|
        found = rebuilt.related_videos_ids.find do |potential|
          potential == vid
        end

        _(found).must_equal vid
        # this statement seems to be redundant
      end
    end

    it 'HAPPY: should find and return existing project in database' do
      # GIVEN: a valid keyword request for a topic already in the database:
      keyword = HeadlineConnector::Forms::NewTopic.new.call(keyword: TOPIC_NAME)
      db_topic = HeadlineConnector::Service::AddTopic.new.call(keyword).value!

      # WHEN: the service is called with the request form object
      topic_made = HeadlineConnector::Service::AddTopic.new.call(keyword)

      # THEN: the result should report success..
      _(topic_made.success?).must_equal true

      # ..and find the same project that was already in the database
      rebuilt = topic_made.value!
      _(rebuilt.id).must_equal(db_topic.id)

      # ..and provide a project entity with the right details
      db_topic.related_videos_ids.each do |vid|
        found = rebuilt.related_videos_ids.find do |potential|
          potential == vid
        end

        _(found).must_equal vid
        # this statement seems to be redundant
      end
    end

    it 'BAD: should gracefully fail for invalid keyword' do
      # GIVEN: an invalid keyword request is formed
      BAD_TOPIC_NAME = '\n'
      keyword = HeadlineConnector::Forms::NewTopic.new.call(keyword: BAD_TOPIC_NAME)

      # WHEN: the service is called with the request form object
      topic_made = HeadlineConnector::Service::AddTopic.new.call(keyword)

      # THEN: the service should report failure with an error message
      _(topic_made.success?).must_equal false
      _(topic_made.failure.downcase).must_include 'invalid'
    end
  end
end
