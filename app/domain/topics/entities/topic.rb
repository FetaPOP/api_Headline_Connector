# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

require_relative 'feed'

module HeadlineConnector
  module Entity
    # Entity class
    class Topic < Dry::Struct
      # Entity class of Topic
      include Dry.Types

      attribute :id,                    Integer.optional
      attribute :keyword,               Strict::String
      attribute :related_videos_ids,    Strict::Array.of(Strubg)

      def self.build_empty_entity
        HeadlineConnector::Entity::Topic.new(
          id: nil,
          keyword: '',
          related_videos_ids: []
        )
      end
    end
  end
end