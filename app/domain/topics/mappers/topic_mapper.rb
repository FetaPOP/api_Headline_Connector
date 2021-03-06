# frozen_string_literal: true

module HeadlineConnector
  module Youtube
        # Youtube Mapper: YoutubeApi -> Topic entity
        class TopicMapper
            def initialize(api_key, gateway_class = Youtube::Api)
                @api_key = api_key
                @gateway_class = gateway_class
                @gateway = @gateway_class.new(@api_key)
            end
            
            def search_keyword(keyword, max_results = 50)
                data = @gateway.search_keyword(keyword, max_results)
                build_entity(data, keyword)
            end

            def build_entity(data, keyword)
                DataMapper.new(data, keyword).build_entity
            end

            def self.build_entity(data, keyword)
                DataMapper.new(data, keyword).build_entity
            end
        end

        # Extracts entity specific elements from youtube-returned data structures
        class DataMapper
            def initialize(data, keyword)
                @data = data
                @keyword = keyword
            end

            def extract_video_ids
                @data['items'].keep_if do |items|
                    !items['id']['videoId'].nil?
                end

                @data['items'].map do |items|
                    items['id']['videoId']
                end
            end

            def build_entity
                if @data['items'].empty?
                    return HeadlineConnector::Entity::Topic.new(
                        id: nil,
                        keyword: '',
                        related_videos_ids: []
                    )
                end
                
                HeadlineConnector::Entity::Topic.new(
                    id: nil,
                    keyword: @keyword,
                    related_videos_ids: related_videos_ids
                )
            end

            def related_videos_ids
                extract_video_ids
            end
        end
    end
end