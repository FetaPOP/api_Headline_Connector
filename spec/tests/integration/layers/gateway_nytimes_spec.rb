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
      #puts headlines
    end
  end
  
  describe 'Headline Cluster information' do
    it 'HAPPY: should generate our headline cluster structure' do
      cluster = HeadlineConnector::Mapper::HeadlineClusterMapper.new().generate_headline_cluster
      _(cluster.by_sections).must_be_instance_of Hash

      puts cluster.by_sections

      cluster.by_sections.each do |section, article_array|
        
        _(article_array).must_be_instance_of Array

        article_array.each do |article|
          _(article[:article_url]).must_be_instance_of String
          _(article[:section]).must_be_instance_of String
          _(article[:tag]).must_be_instance_of String
          _(article[:title]).must_be_instance_of String
          _(article[:abstract]).must_be_instance_of String
          _(article[:img]).must_be_instance_of String
        end

      end
    end
  end
end