# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module HeadlineConnector
  module Entity
    class Provider < Dry::Struct
      include Dry.Types

      attribute :id,             Integer.optional
      attribute :provider_id,    Strict::String
      attribute :provider_title, Strict::String
    end

    def to_attr_hash
      to_hash.reject { |key, _| [:id].include? key }
    end
  end
end
