# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module HeadlineConnector
  module Entity
    # Entity class
    class TextCloud < Dry::Struct
      # Entity class of TextCloud
      include Dry.Types

      attribute :stats,    Strict::Array.of(Hash)
      # stats = [{keyword: "surfing", appearTimes: 2}, {keyword: "covid", appearTimes: 21}, ...]
    end
  end
end