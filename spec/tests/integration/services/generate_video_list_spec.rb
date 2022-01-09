# frozen_string_literal: true

require_relative '../../../helpers/spec_helper.rb'
require_relative '../../../helpers/vcr_helper.rb'
require_relative '../../../helpers/database_helper.rb'

require 'ostruct'

describe 'GenerateVideoList Service Integration Test' do
  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_youtube(recording: :none)
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Generate a Video List' do
    before do
      DatabaseHelper.wipe_database
    end

    it 'HAPPY: should generate a videolist for an topic existing in the database' do
      # GIVEN: a valid topic that exists locally

      # Before any generate videolist call, we should run AddTopic service first
      # since only the AddTopic service can add topics AND all related videos to the database
      add_topic_result = HeadlineConnector::Service::AddTopic.new.call(
        requested: HeadlineConnector::Request::TopicRequest.new(TOPIC_NAME, nil)
      )

      _(add_topic_result.success?).must_equal true

      # WHEN: we request to generate a video list
    
      result = HeadlineConnector::Service::GenerateVideoList.new.call(
        requested: HeadlineConnector::Request::VideoListRequest.new(TOPIC_NAME, nil)
      )

      # THEN: the result should report success.
      _(result.success?).must_equal true

      # ..and we should get a video list
      video_list = result.value!.message
      _(video_list).must_be_kind_of HeadlineConnector::Entity::VideoList
      _(video_list.this_week).must_be_kind_of Array
      _(video_list.this_month).must_be_kind_of Array
      _(video_list.this_year).must_be_kind_of Array
      _(video_list.before_this_year).must_be_kind_of Array

      _(video_list.this_week[0]).must_be_kind_of String unless video_list.this_week.empty?
      _(video_list.this_month[0]).must_be_kind_of String unless video_list.this_month.empty?
      _(video_list.this_year[0]).must_be_kind_of String unless video_list.this_year.empty?
      _(video_list.before_this_year[0]).must_be_kind_of String unless video_list.before_this_year.empty?     
    end

    it 'SAD: should not generate a video list for a topic not existing in the database' do
      # GIVEN: no topic exists locally

      # WHEN: we request to generate a video list
      request = OpenStruct.new(
        keyword: TOPIC_NAME
      )
      
      puts
      puts "The terminal should print some errors now: "
      result = HeadlineConnector::Service::GenerateVideoList.new.call(requested: request)

      # THEN: we should get failure
      _(result.failure?).must_equal true
    end
  end
end
