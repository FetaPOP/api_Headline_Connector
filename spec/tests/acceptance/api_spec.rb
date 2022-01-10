# frozen_string_literal: true

require_relative '../../helpers/spec_helper'
require_relative '../../helpers/vcr_helper'
require_relative '../../helpers/database_helper'
require 'rack/test'

def app
  HeadlineConnector::App
end

describe 'Test API routes' do
  include Rack::Test::Methods

  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_youtube
    DatabaseHelper.wipe_database
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Root route' do
    it 'should successfully return root information' do
      get '/'
      _(last_response.status).must_equal 200

      body = JSON.parse(last_response.body)
      _(body['status']).must_equal 'ok'
      _(body['message']).must_include 'api/v1'
    end
  end

  describe 'Generate Text Cloud' do
    it 'should be able to return a text cloud' do
      HeadlineConnector::Service::AddTopic.new.call(
        requested: HeadlineConnector::Request::TextCloudRequest.new(TOPIC_NAME, nil)
      )
      
      # get /api/v1/textcloud/#{TOPIC_NAME} will do generate_text_cloud service
      get "/api/v1/textcloud/#{TOPIC_NAME}"
      _(last_response.status).must_equal 200
      text_cloud = JSON.parse(last_response.body)
      _(text_cloud['stats']).wont_be_nil
    end
  end

  describe 'Add Topic' do
    it 'should be able to add a topic' do
      post "/api/v1/topics/#{TOPIC_NAME}"

      _(last_response.status).must_equal 201

      topic = JSON.parse last_response.body
      _(topic['keyword']).must_equal TOPIC_NAME
      _(topic['related_videos_ids']).must_be_kind_of Array
    end
  end

  describe 'Headline Cluster' do
    it 'should be able to generate a headline cluster' do
      get "/api/v1/headline_cluster"

      _(last_response.status).must_equal 200

      headline_cluster = HeadlineConnector::Representer::HeadlineCluster.new(OpenStruct.new).from_json(last_response.body)
      
      _(headline_cluster.sections).must_be_kind_of Hash
      headline_cluster.sections.each do |section, article_array|
        _(article_array).must_be_kind_of Array
        article_array.each do |article|
          _(article_array).wont_be_empty
        end
      end
    end
  end

  describe 'Video List' do
    it 'should be able to generate a video list' do
      HeadlineConnector::Service::AddTopic.new.call(
        requested: HeadlineConnector::Request::TextCloudRequest.new(TOPIC_NAME, nil)
      )

      get "/api/v1/video_list/#{TOPIC_NAME}"

      _(last_response.status).must_equal 200
      
      video_list = HeadlineConnector::Representer::VideoList.new(OpenStruct.new).from_json(last_response.body)
      _(video_list['this_week']).must_be_kind_of Array
      _(video_list['this_month']).must_be_kind_of Array
      _(video_list['this_year']).must_be_kind_of Array
      _(video_list['before_this_year']).must_be_kind_of Array

      _(video_list['this_week'][0]).must_be_kind_of String unless video_list['this_week'].empty?
      _(video_list['this_month'][0]).must_be_kind_of String unless video_list['this_month'].empty?
      _(video_list['this_year'][0]).must_be_kind_of String unless video_list['this_year'].empty?
      _(video_list['before_this_year'][0]).must_be_kind_of String unless video_list['before_this_year'].empty?  
    end
  end
end