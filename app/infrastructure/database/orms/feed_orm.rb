# frozen_string_literal: true

require 'sequel'

module HeadlineConnector
  module Database
    # Object Relational Mapper for Feed Entities
    class FeedOrm < Sequel::Model(:feeds)
      many_to_one :provider,
                  class: :'HeadlineConnector::Database::ProviderOrm'

      many_to_many :related_topics,
                  class: :'HeadlineConnector::Database::TopicOrm',
                  join_table: :feeds_topics,
                  left_key: :feed_id, right_key: :keyword

      plugin :timestamps, update_on_create: true
    end
  end
end
