# frozen_string_literal: true

require_relative '../../../helpers/spec_helper'
require_relative '../../../helpers/vcr_helper'

describe 'Tests NYTimes API library' do
  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_youtube(recording: :none)
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Headlines information' do
    it 'HAPPY: should generate our headlines entity' do
      headlines = HeadlineConnector::NYTimes::HeadlinesMapper.new(NYTIMES_TOKEN).request_headlines
      _(headlines.headlines).must_be_instance_of Array
      headlines.headlines.each do |headline|
        _(headline).must_be_instance_of HeadlineConnector::Entity::Headline
      end
    end
  end
  
  describe 'Headline Cluster information' do
    it 'HAPPY: should generate our headline cluster structure' do
      cluster = HeadlineConnector::Mapper::HeadlineClusterMapper.new().generate_headline_cluster
      _(cluster.sections).must_be_instance_of Hash

      cluster.sections.each do |section, article_array|
        _(article_array).must_be_instance_of Array
        article_array.each do |article|
          _(article).must_be_instance_of Hash
        end
      end
    end
  end
end