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
          related_feeds: Feeds.rebuild_many(db_topic_record.related_feeds)
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
          Database::TopicOrm.create(keyword: @entity.keyword)
        end

        def call
          create_topic.tap do |a_topic_from_db|
            @entity.related_feeds.each do |feed_entity|
              a_topic_from_db.add_related_feed(Feeds.db_find_or_create(feed_entity))
            end
          end
        end
      end
    end
  end
end
