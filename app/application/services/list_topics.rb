# frozen_string_literal: true

require 'dry/monads'

module HeadlineConnector
  module Service
    # Retrieves array of all listed project entities
    class ListTopics
      include Dry::Monads::Result::Mixin

      def call(topics_list)
        topics = Repository::For.klass(Entity::Topic)
          .find_topic_names(topics_list)

        Success(topics)
      rescue StandardError
        Failure('Could not access database')
      end
    end
  end
end
