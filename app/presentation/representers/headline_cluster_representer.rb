# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

# Represents essential feeds and text_cloud of a topic for API output
module HeadlineConnector
  module Representer
    # Represent a Topic entity as Json
    class HeadlineCluster < Roar::Decorator
      include Roar::JSON

      property :sections
    end
  end
end