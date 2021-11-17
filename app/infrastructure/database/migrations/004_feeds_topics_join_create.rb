# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    
    create_table(:feeds_topics) do
      primary_key [:feed_id, :topic_id]
      foreign_key :feed_id, :feeds
      foreign_key :topic_id, :topics

      index [:feed_id, :topic_id]
    end
  end
end
