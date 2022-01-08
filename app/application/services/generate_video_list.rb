# frozen_string_literal: true

require 'dry/transaction'

module HeadlineConnector
  module Service
    # Transactions to generate a video_list for a keyword
    # Make sure to run "add_topic" service (to add missing videos to the database) before running this service
    class GenerateVideoList
      include Dry::Transaction

      step :retrieve_topic
      step :request_videos
      step :generate_video_list

      private

      TOPIC_DB_FIND_ERR_MSG = 'Topic not found'
      TOPIC_DB_RELATED_FEEDS_ERR_MSG = 'Having some troubles abount finding related feeds of a topic in the database'
      VIDEO_LIST_CALCULATION_ERR_MSG = 'Having some troubles conducting generate_videolist() calculations'
      VIDEO_LIST_NO_RESULT_ERR_MSG = 'The generated video list contains nothing'

      def retrieve_topic(input)
        input[:topic] = Repository::For.klass(Entity::Topic).find_topic_keyword(input[:requested].keyword)

        if input[:topic]
          Success(input)
        else
          Failure(Response::ApiResult.new(status: :not_found, message: TOPIC_ERR_MSG))
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
        Failure(Response::ApiResult.new(status: :not_found, message: TOPIC_DB_RELATED_FEEDS_ERR_MSG))
      end

      def generate_video_list(input)
          input[:videolist] = Mapper::VideoListMapper.new(input[:related_feeds_entities]).generate_videolist
    
          if input[:videolist]
            Success(Response::ApiResult.new(status: :ok, message: input[:videolist]))
          else 
            Failure(Response::ApiResult.new(status: :bad_request, message: VIDEO_LIST_NO_RESULT_ERR_MSG))
          end

      rescue StandardError => error
        puts error.backtrace.join("\n")
        Failure(Response::ApiResult.new(status: :internal_error, message: VIDEO_LIST_CALCULATION_ERR_MSG))
      end
    end
  end
end
