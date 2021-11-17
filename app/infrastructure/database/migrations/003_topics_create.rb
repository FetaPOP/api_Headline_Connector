# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:topics) do
      primary_key :id
      foreign_key :feed_id, :feeds

      String      :topic_id, unique: true

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
