# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

require_relative 'headline'

module HeadlineConnector
  module Entity
    # Entity class
    class Headlines < Dry::Struct
      # Entity class of Headlines
      include Dry.Types

      attribute :id,            Integer.optional
      attribute :headlines,     Strict::Array.of(Headline)
    end
  end
end
