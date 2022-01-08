# frozen_string_literal: true

module HeadlineConnector
  module Mapper
    # Mapper: Topic -> VideoList entity
    class VideoListMapper
      def initialize(related_feed_entities_array)
        @related_feed_entities_array = related_feed_entities_array
      end
           
      def generate_videolist
        # Filter out irrelevant infos in the feed entities into an Array of Hashes
        related_feeds_with_only_time_and_feedid = @related_feed_entities_array.map do |feed|
          {
            :feed_id => feed.feed_id,
            :publishedAt => feed.publishedAt
          }
        end

        build_entity(Value::VideoList.calculate(related_feeds_with_only_time_and_feedid))
      end
  
      def build_entity(video_list_hash)
        Entity::VideoList.new(video_list_hash)
      end
    end
  end
end