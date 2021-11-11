# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:feeds) do
      primary_key :id
      foreign_key :owner_id, :providers

      String      :feed_id, unique: true
      String      :feed_title
      String      :description
      String      :tags
      # Note that "tags" in our Feed Entities is Array. Be careful of the conversion of Array <-> String

      DateTime :created_at
      DateTime :updated_at
    end
  end
end