# frozen_string_literal: true

module HeadlineConnector
  module Youtube
    # Youtube Mapper: YoutubeApi -> Video entity
    class FeedMapper
      def initialize(api_key, gateway_class = Youtube::Api)
        @api_key = api_key
        @gateway_class = gateway_class
        @gateway = @gateway_class.new(@api_key)
      end

      def find(id)
        data = @gateway.collect_data(id)
        build_entity(data)
      end

      def build_entity(data)
        DataMapper.new(data).build_entity
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(data)
          @data = data
        end

        def build_entity
          if @data['items'] == []
            return HeadlineConnector::Entity::Feed.new(
              id: '',
              title: '',
              description: '',
              tags: [],
              provider: ''
            )
          end

          HeadlineConnector::Entity::Feed.new(
            id: id,
            title: title,
            description: description,
            tags: tags,
            provider: provider
          )
        end

        def id
          @data['items'][0]['id']
        end

        def title
          @data['items'][0]['snippet']['title']
        end

        def description
          @data['items'][0]['snippet']['description']
        end

        def tags
          @data['items'][0]['snippet']['tags']
        end
    
        def provider
          @data['items'][0]['snippet']['channelTitle']
        end
      end
    end
  end
end
