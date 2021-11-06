# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module HeadlineConnector
  module Entity
    class Provider < Dry::Struct
      include Dry.Types

      attribute :provider_id,    Strict::String
      attribute :provider_title, Strict::String
    end
  end
end
