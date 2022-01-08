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

      # useful method for debugging
      def print_on_terminal        
        puts "1. article_url: " + article_url if article_url
        puts "2. section: " + section if section
        puts "3. tag: " + tag if tag
        puts "4. title: " + title if title
        puts "5. abstract: " + abstract if abstract
        puts "6. img: " + img if img
        puts 
      end
    end
  end
end
