# frozen_string_literal: true

module HeadlineConnector
  module Mapper
        # Youtube Mapper: YoutubeApi -> Topic entity
        class TextCloudMapper
            def initialize(related_feeds)
                @related_feeds = related_feeds
            end
            
            def generate_textcloud
                # get all the tags from the feeds
                tags_list = @related_feeds.map do |feed|
                    feed.tags if feed.tags
                    # collect all tags from each feed and make it an array
                end
                
                build_entity(Value::TextCloud.calculate(tags_list.flatten))
            end

            def build_entity(stats)
                Entity::TextCloud.new(stats: stats)
            end
        end
    end
end