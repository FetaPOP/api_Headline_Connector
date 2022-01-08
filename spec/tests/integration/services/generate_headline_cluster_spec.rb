# frozen_string_literal: true

require_relative '../../../helpers/spec_helper.rb'
require_relative '../../../helpers/vcr_helper.rb'
require_relative '../../../helpers/database_helper.rb'

require 'ostruct'

describe 'GenerateHeadlineCluster Service Integration Test' do
  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_youtube(recording: :none)
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Generate a Headline Cluster' do
    before do
      DatabaseHelper.wipe_database
    end

    it 'HAPPY: should generate a headline cluster' do
      # GIVEN: NYTimes API is working

      # WHEN: we request to generate a headline cluster
      
      result = HeadlineConnector::Service::GenerateHeadlineCluster.new.call(
        requested: HeadlineConnector::Request::HeadlineClusterRequest.new(nil)
      )

      # THEN: the result should report success.
      _(result.success?).must_equal true

      # ..and we should get a headline cluster
      headline_cluster = result.value!.message
      _(headline_cluster).must_be_kind_of HeadlineConnector::Entity::HeadlineCluster
      _(headline_cluster.sections).wont_be_empty
      headline_cluster.sections.each do |section, article_array|
        _(article_array).wont_be_empty
        _(article_array[0]).must_be_kind_of Hash
      end
    end
  end
end
