# frozen_string_literal: true

require 'dry/transaction'

module HeadlineConnector
  module Service
    # Analyzes contributions to a project
    class GenerateTextCloud
      include Dry::Transaction

      step :retrieve_topic
      step :request_videos
      step :generate_text_cloud

      private

      DB_ERR = 'Having some troubles conducting retrieve_topic() on the database'
      NO_PROJ_ERR = 'Topic Not Found'
      YT_REQ_ERR = 'Having some troubles conducting request_videos() to the Youtube Api'
      TEXT_CLOUD_ERR = 'Fail to generate textcloud'
      TEXT_CLOUD_CALC_ERR = 'Having some troubles conducting generate_text_cloud() calculations'

      def retrieve_topic(input)
        input[:topic] = Repository::For.klass(Entity::Topic).find_topic_keyword(input[:keyword])

        if input[:topic] 
          Success(input)
        else
          Failure(Response::ApiResult.new(status: :not_found, message: NO_PROJ_ERR))
        end
      rescue StandardError
        Failure(Response::ApiResult.new(status: :internal_error, message: DB_ERR))
      end

      def request_videos(input)
        # Assume that all related videos are already in the database
        input[:related_feeds_entities] = input[:topic].related_videos_ids.map do |video_id|
          Repository::For.klass(Entity::Feed).find_feed_id(video_id)
        end

        input[:related_feeds_entities].each do |x|
          puts x.feed_id
        end
        
        Success(input)
      rescue StandardError
        puts error.backtrace.join("\n")
        raise YT_REQ_ERR
      end

      def generate_text_cloud(input)
        input[:textcloud] = Mapper::TextCloudMapper.new(input[:related_feeds_entities]).generate_textcloud
  
        if input[:textcloud]
          Success(input)
        else
          Failure(Response::ApiResult.new(status: :not_found, message: TEXT_CLOUD_ERR))
        end
      rescue StandardError
        puts error.backtrace.join("\n")
        Failure(Response::ApiResult.new(status: :not_found, message: TEXT_CLOUD_CALC_ERR))
      end
    end
  end
end



            
