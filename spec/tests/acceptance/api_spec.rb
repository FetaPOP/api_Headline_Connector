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
    VcrHelper.configure_vcr_for_github
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
    it 'should be able to add a topic' do
      Service::AddTopic.new.call(keyword: TOPIC_NAME)

      get "/api/v1/projects/topics/#{TOPIC_NAME}"
      _(last_response.status).must_equal 200
      topic = JSON.parse last_response.body
      _(topic['keyword']).must_equal TOPIC_NAME

    end
  end

  describe 'Add Topic' do
    it 'should be able to add a topic' do
      post "/api/v1/projects/topics/#{TOPIC_NAME}"

      _(last_response.status).must_equal 201

      topic = JSON.parse last_response.body
      _(topic['keyword']).must_equal TOPIC_NAME
      _(topic['related_videos_ids']).must_be_kind_of Strict::Array.of(String)

      topi = HeadlineConnector::Representer::Topic.new(
        HeadlineConnector::Representer::OpenStructWithLinks.new
      ).from_json last_response.body
      _(topi.links['self'].href).must_include 'http'
    end

    it 'should report error for invalid projects' do
      post "/api/v1/projects/topics/NonExistedTopic"

      _(last_response.status).must_equal 404

      response = JSON.parse(last_response.body)
      _(response['message']).must_include 'not'
    end
  end

end