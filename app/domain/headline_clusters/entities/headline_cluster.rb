# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module HeadlineConnector
  module Entity
    # Entity class
    class HeadlineCluster < Dry::Struct
      # Entity class of HeadlineCLuster
      include Dry.Types

      attribute :id,            Integer.optional
      attribute :sections,   Strict::Hash
    end
  end
end