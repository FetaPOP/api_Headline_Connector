# frozen_string_literal: true

module HeadlineConnector
  module Mapper
    # Mapper: Topic -> TextCloud entity
    class TextCloudMapper
      def initialize(related_feeds)
        @related_feeds = related_feeds
      end
           
      def generate_textcloud
        # get all the tags from the feeds
        tags_list = @related_feeds.map do |feed|
          feed.tags if feed.tags # collect all tags from each feed and make it an array          
        end
                  
        build_entity(Value::TextCloud.calculate(tags_list.flatten))
      end
  
      def build_entity(textcloud_array)
        textcloud_array.sort_by! do |small_array|
          small_array["appearTimes"] 
        end
  
        Entity::TextCloud.new(stats: textcloud_array.reverse) # return the test_cloud stats array with the largest to the smallest
       end
    end
  end
end