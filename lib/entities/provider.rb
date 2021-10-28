# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module HeadlineConnector
  module Entity
    class Provider < Dry::Struct
      include Dry.Types

      attribute :channel_id,    Strict::Integer
      attribute :channel_title, Strict::String
    end
  end
end