# frozen_string_literal: true

require 'dry/transaction'

module HeadlineConnector
  module Service
    # Transactions to store topic from Youtube API to database
    class AddTopic
      include Dry::Transaction

      step :find_topic
      step :store_topic

      private

      DB_ERR_MSG = 'Having some troubles conducting find_topic_keyword() on the database'
      YT_NOT_FOUND_MSG = 'Having some troubles conducting search_keyword() on the Youtube Api'
      STORE_ERR_MSG = 'Having some troubles in store_topic() service'
      SEARCH_STORE_ERR_MSG = 'Having some troubles about search_and_store_missing_feeds()'
      FIND_FEEDID_DB_ERR_MSG = 'Having some troubles about find_feed_id_in_database()'
      YT_REQ_ERR_MSG = 'Having some troubles about request_video_from_youtube()'
      STORE_FEED_TO_DB_ERR_MSG = 'Having some troubles about store_feed_to_database()'

      # Expects input[:keyword]
      def find_topic(input)
        if (topic = topic_entity_in_database(input[:requested].keyword))
          input[:local_topic] = topic
        else
          input[:remote_topic] = topic_entity_from_youtube(input[:requested].keyword)
        end
        Success(input)
      rescue StandardError => error
        puts error.backtrace.join("\n")
        Failure(Response::ApiResult.new(status: :not_found, message: error.to_s))
      end

      def store_topic(input)
        topic_entity =
          if (input[:remote_topic])
            # Search on Youtube and store those related videos/feeds that are not found in the database
            # This step is necessary for building the many-to-many feed-topic table in the database
            request_storing_feeds_worker(input[:remote_topic])
            
            Repository::For.klass(Entity::Topic).create(input[:remote_topic])
          else
            input[:local_topic]
          end

        Response::TopicResponse.new(topic_entity.keyword, topic_entity.related_videos_ids)
          .then do |topic_response|
            Success(Response::ApiResult.new(status: :created, message: topic_response))
          end
        
      rescue StandardError => error
        puts error.backtrace.join("\n")
        Failure(Response::ApiResult.new(status: :internal_error, message: STORE_ERR_MSG))
      end

      # Support methods for steps

      def topic_entity_from_youtube(keyword)
        Youtube::TopicMapper
        .new(App.config.YOUTUBE_TOKEN)
        .search_keyword(keyword)
      rescue StandardError
        puts error.backtrace.join("\n")
        raise YT_NOT_FOUND_MSG
      end

      def topic_entity_in_database(keyword)
        Repository::For.klass(Entity::Topic).find_topic_keyword(keyword)
      rescue StandardError
        puts error.backtrace.join("\n")
        raise DB_ERR_MSG
      end

      def request_storing_feeds_worker(topic_entity)
        Messaging::Queue
          .new(App.config.CLONE_QUEUE_URL, App.config)
          .send(Representer::Topic.new(topic_entity).to_json)

        Failure(Response::ApiResult.new(status: :processing, message: PROCESSING_MSG))
      rescue StandardError => e
        print_error(e)
        Failure(Response::ApiResult.new(status: :internal_error, message: CLONE_ERR))
      end
    end
  end
end