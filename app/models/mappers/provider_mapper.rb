# frozen_string_literal: true

module HeadlineConnector
  module Youtube
    # Youtube Mapper: YoutubeApi -> provider entity
    class ProviderMapper
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
          return nil if @data['items'] == []

          HeadlineConnector::Entity::Provider.new(
            channel_id: id,
            channel_title: title
          )
        end

        def id
          @data['items'][0]['snippet']['channelId']
        end

        def title
          @data['items'][0]['snippet']['channelTitle']
        end
      end
    end
  end
end
