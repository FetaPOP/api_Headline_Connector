# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module HeadlineConnector
  module Entity
    # Entity class
    class VideoList < Dry::Struct
      # Entity class of TextCloud
      include Dry.Types

      attribute :this_week,         Strict::Array.of(String)
      attribute :this_month,        Strict::Array.of(String)
      attribute :this_year,         Strict::Array.of(String)
      attribute :before_this_year,  Strict::Array.of(String)
      
      #"This Week": ["ma67yOdMQfs", "wZYeAZtJUnE"],
      #"This month": ["A5oD6RhwCi0"],
      #"This Year": ["W7h-Yho8EB0"],
      #"Before this year": ["aS-NoUsMcac","3Ym2FjufYJM"]

      # useful method for debugging
      def print_on_terminal
        puts "this_week"    
        puts this_week
        puts
        puts "this_month"
        puts this_month
        puts 
        puts "this_year"
        puts this_year
        puts 
        puts "before_this_year"
        puts before_this_year
        puts 
      end
    end
  end
end