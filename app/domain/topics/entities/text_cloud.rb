# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

require_relative 'feed'

module HeadlineConnector
  module Entity
    # Entity class
    class TextCloud < Dry::Struct
      # Entity class of Topic
      include Dry.Types

      attribute :tags_data,    Strict::Hash
    end
  end
end