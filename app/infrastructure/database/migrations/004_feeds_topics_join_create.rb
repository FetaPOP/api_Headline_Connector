# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:feeds_topics) do
      primary_key [:feed_id, :keyword]
      foreign_key :feed_id, :feeds
      foreign_key :keyword, :topics

      index [:feed_id, :keyword]
    end
  end
end
