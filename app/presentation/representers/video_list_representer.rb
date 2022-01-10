# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

# Represents essential feeds and text_cloud of a topic for API output
module HeadlineConnector
  module Representer
    # Represent a Topic entity as Json
    class VideoList < Roar::Decorator
        include Roar::JSON

        collection :this_week
        collection :this_month
        collection :this_year
        collection :before_this_year

        # e.g.
        # This Week: ["ma67yOdMQfs", "wZYeAZtJUnE"]
        # This month: ["A5oD6RhwCi0"]
        # This Year: ["W7h-Yho8EB0"]
        # Before this year: ["aS-NoUsMcac","3Ym2FjufYJM"]
    end
  end
end