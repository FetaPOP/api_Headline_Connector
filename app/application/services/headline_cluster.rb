# frozen_string_literal: true

require 'dry/transaction'

module HeadlineConnector
  module Service
    # Analyzes contributions to a project
    class GenerateTextCloud
      include Dry::Transaction

      step :request_nytimes_headline
      step :process_headline

      private

      NYTIMES_HEADLINE_API_ERR_MSG = 'Having some troubles requesting headlines from NYTimes api'
      HEADLINE_PROCESSING_ERR_MSG = 'Having some troubles processing headlines'

      def request_nytimes_headline(input)
        # Mapper
        api_response = NYTimes::Api.new(App.config.NYTIMES_TOKEN).request_headlines(1)
        api_response[results].map



      rescue StandardError => error
        puts error.backtrace.join("\n")
        Failure(Response::ApiResult.new(status: :not_found, message: NYTIMES_HEADLINE_API_ERR_MSG))
      end

      def process_headline(input)
        # Assume that all related videos are already in the database
        input[:related_feeds_entities] = input[:topic].related_videos_ids.map do |video_id|
          Repository::For.klass(Entity::Feed).find_feed_id(video_id)
        end
        
        Success(input)
        
      rescue StandardError => error
        puts error.backtrace.join("\n")
        Failure(Response::ApiResult.new(status: :not_found, message: HEADLINE_PROCESSING_ERR_MSG))
      end
    end
  end
end
