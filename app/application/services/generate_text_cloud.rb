# frozen_string_literal: true

require 'dry/transaction'

module HeadlineConnector
  module Service
    # Transactions to generate a textcloud for a keyword
    # Make sure to run "add_topic" service (to add missing videos to the database) before running this service
    class GenerateTextCloud
      include Dry::Transaction

      step :retrieve_topic
      step :request_videos
      step :generate_text_cloud

      private

      TOPIC_DB_FIND_ERR_MSG = 'Topic not found'
      TOPIC_DB_RELATED_FEEDS_ERR_MSG = 'Having some troubles abount finding related feeds of a topic in the database'
      TEXT_CLOUD_CALCULATION_ERR_MSG = 'Having some troubles conducting generate_textcloud() calculations'
      TEXT_CLOUD_NO_RESULT_ERR_MSG = 'The generated text cloud contains nothing'

      def retrieve_topic(input)
        input[:topic] = Repository::For.klass(Entity::Topic).find_topic_keyword(input[:requested].keyword)

        if input[:topic]
          Success(input)
        else
          Failure(Response::ApiResult.new(status: :internal_error, message: TOPIC_ERR_MSG))
        end

      rescue StandardError => error
        puts error.backtrace.join("\n")
        Failure(TOPIC_DB_FIND_ERR_MSG)
      end

      def request_videos(input)
        # Assume that all related videos are already in the database
        input[:related_feeds_entities] = input[:topic].related_videos_ids.map do |video_id|
          Repository::For.klass(Entity::Feed).find_feed_id(video_id)
        end
        
        Success(input)
        
      rescue StandardError => error
        puts error.backtrace.join("\n")
        Failure(Response::ApiResult.new(status: :internal_error, message: TOPIC_DB_RELATED_FEEDS_ERR_MSG))
      end

      def generate_text_cloud(input)
          input[:textcloud] = Mapper::TextCloudMapper.new(input[:related_feeds_entities]).generate_textcloud
    
          if input[:textcloud]
            Success(Response::ApiResult.new(status: :ok, message: input[:textcloud]))
          else 
            Failure(Response::ApiResult.new(status: :bad_request, message: TEXT_CLOUD_NO_RESULT_ERR_MSG))
          end

      rescue StandardError => error
        puts error.backtrace.join("\n")
        Failure(Response::ApiResult.new(status: :internal_error, message: TEXT_CLOUD_CALCULATION_ERR_MSG))
      end
    end
  end
end
