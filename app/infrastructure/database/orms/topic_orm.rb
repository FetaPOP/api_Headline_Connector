# frozen_string_literal: true

require 'sequel'

module HeadlineConnector
  module Database
    # Object Relational Mapper for Topic Entities
    class TopicOrm < Sequel::Model(:topics)
      many_to_many :related_feeds,
                    class: :'HeadlineConnector::Database::FeedOrm',
                    join_table: :feeds_topics,
                    left_key: :keyword, right_key: :feed_id

      plugin :timestamps, update_on_create: true 
    end
  end
end
