# frozen_string_literal: true

require_relative 'providers'

module HeadlineConnector
  module Repository
    # Repository for Feed Entities
    class Topics
      def self.all
        Database::TopicOrm.all.map { |a_topic_from_db| rebuild_entity(a_topic_from_db) }
      end

      def self.find(topic_entity)
        find_topic(topic_entity.keyword)
      end

      def self.find_topic_keyword(keyword)
        rebuild_entity Database::TopicOrm.first(keyword: keyword)
      end
 
      def self.rebuild_entity(db_topic_record)
        return nil unless db_topic_record

        Entity::Topic.new(
          id: db_topic_record.id,
          keyword: db_topic_record.keyword
          related_feeds: db_topic_record.related_feeds
          provider: Providers.rebuild_entity(db_feed_record.provider)
          # db_feed_record.provider is a Database::ProviderOrm object
        )
      end

      def self.create(topic_entity)
        raise 'Topic already exists' if find(topic_entity)

        db_topic_record = PersistProject.new(topic_entity).call
        rebuild_entity(db_topic_record)
      end

      class PersistProject
        def initialize(entity)
          @entity = entity
        end

        def create_topic
          Database::TopicOrm.create(@entity.to_attr_hash)
        end

        def call
          provider = Members.db_find_or_create(@entity.provider)

          create_project.tap do |db_project|
            db_project.update(provider: provider)

            @entity.contributors.each do |contributor|
              db_project.add_contributor(Members.db_find_or_create(contributor))
            end
          end
        end
      end
    end
  end
end
