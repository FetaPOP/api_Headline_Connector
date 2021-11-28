# frozen_string_literal: true

require 'dry/transaction'

module HeadlineConnector
  module Service
    # Transaction to store project from Github API to database
    class AddTopic
      include Dry::Transaction

      step :find_topic
      step :store_topic

      private

      def find_topic(input)
        if (topic = topic_in_database(input))
          input[:local_topic] = topic
        else
          input[:remote_topic] = topic_from_youtube(input)
        end
        Success(input)
      rescue StandardError => error
        Failure(error.to_s)
      end

      def store_topic(input)
        topic =
          if (new_topic = input[:remote_topic])
            Repository::For.entity(topic).create(topic)
          else
            input[:local_topic]
          end
        Success(topic)
      rescue StandardError => error
        puts error.backtrace.join("\n")
        Failure('Having trouble accessing the database')
      end

      # following are support methods that other services could use

      def topic_from_youtube(input)
        Youtube::TopicMapper
        .new(App.config.YOUTUBE_TOKEN)
        .search_keyword(input)
      rescue StandardError
        raise 'Could not find Youtube videos by this keyword'
      end

      def topic_in_database(input)
        Repository::For.klass(Entity::Topic).find_topic_name(input)
      end
    end
  end
end