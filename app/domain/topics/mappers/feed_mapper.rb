# frozen_string_literal: true

require_relative 'provider_mapper'

module HeadlineConnector
  module Youtube
    # Youtube Mapper: YoutubeApi -> Feed entity
    class FeedMapper
      def initialize(api_key, gateway_class = Youtube::Api)
        @api_key = api_key
        @gateway_class = gateway_class
        @gateway = @gateway_class.new(@api_key)
      end

      def request_video(id)
        data = @gateway.request_video(id)
        build_entity(data)
      end

      def build_entity(data)
        DataMapper.new(data).build_entity
      end

      def self.build_entity(data)
        DataMapper.new(data).build_entity
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(data)
          @data = data
        end

        def build_entity
          return nil if @data['items'].empty?

          HeadlineConnector::Entity::Feed.new(
            id: nil,
            feed_id: feed_id,
            feed_title: feed_title,
            description: description,
            publishedAt: publishedAt,
            tags: tags,
            provider: provider
          )
        end

        def feed_id
          @data['items'][0]['id']
        end

        def feed_title
          @data['items'][0]['snippet']['title']
        end

        def description
          @data['items'][0]['snippet']['description']
        end

        def publishedAt
          @data['items'][0]['snippet']['publishedAt']
        end

        def tags
          @data['items'][0]['snippet']['tags'] || Array.new
        end

        def provider
          Youtube::ProviderMapper.build_entity(@data)
        end
      end
    end
  end
end
