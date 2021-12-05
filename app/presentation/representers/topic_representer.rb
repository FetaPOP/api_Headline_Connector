# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

require_relative 'text_cloud_representer'
require_relative 'feed_representer'

# Represents essential feeds and text_cloud of a topic for API output
module HeadlineConnector
  module Representer
    # Represent a Topic entity as Json
    class Topic < Roar::Decorator
      include Roar::JSON

      property :id
      property :keyword
      property :text_cloud, extend: Representer::TextCloud, class: OpenStruct
      collection :feeds, extend: Representer::Feed, class: OpenStruct

    end
  end
end
