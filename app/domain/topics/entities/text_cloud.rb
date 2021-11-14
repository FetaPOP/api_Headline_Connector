# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

#require_relative 'feed'

module HeadlineConnector
  module Entity
    # Entity class
    class TextCloud < Dry::Struct
      # Entity class of TextCloud
      include Dry.Types

      attribute :text_cloud_stats,    Strict::Array.of(Array)
      # text_cloud_stats = [[data1, count1],[data2, count2],... ]
    end
  end
end