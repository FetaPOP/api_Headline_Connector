# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module HeadlineConnector
  module Entity
    class Feed < Dry::Struct
      include Dry.Types

      attribute :id,            Strict::String
      attribute :title,         Strict::String
      attribute :description,   Strict::String
      attribute :tags,          Strict::Array
      attribute :provider,      Provider
    end
  end
end
