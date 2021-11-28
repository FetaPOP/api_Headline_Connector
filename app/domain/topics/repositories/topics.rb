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
          id: db_feed_record.id,
          feed_id: db_feed_record.feed_id,
          feed_title: db_feed_record.feed_title,
          description: db_feed_record.description,
          tags: db_feed_record.tags.split(','),
          provider: Providers.rebuild_entity(db_feed_record.owner)
          # db_feed_record.owner is a Database::ProviderOrm object
        )
      end

      def self.create(feed_entity)
        raise 'Feed already exists' if find(feed_entity)

        Database::FeedOrm.create(
          feed_id: feed_entity.feed_id,
          feed_title: feed_entity.feed_title,
          description: feed_entity.description,
          tags: feed_entity.tags.join(','),
          owner: Providers.db_find_or_create(feed_entity.provider)
        )
      end
    end
  end
end
