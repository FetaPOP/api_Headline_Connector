# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module HeadlineConnector
  module Entity
    # Entity class
    class Headline < Dry::Struct
      # Entity class of Headline
      include Dry.Types

      attribute :id,            Integer.optional
      attribute :article_url,   Strict::String
      attribute :section,       Strict::String
      attribute :tag,           Strict::String
      attribute :title,         Strict::String
      attribute :abstract,      Strict::String
      attribute :img,           Strict::String.optional
    end
  end
end
