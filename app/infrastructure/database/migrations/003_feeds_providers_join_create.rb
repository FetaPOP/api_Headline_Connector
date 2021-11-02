# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:feeds_providers) do
      primary_key [:feed_id, :provider_id]
      foreign_key :feed_id, :feeds
      foreign_key :provider_id, :providers

      index [:feed_id, :provider_id]
    end
  end
end
