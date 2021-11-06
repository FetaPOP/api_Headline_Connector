# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:feeds) do
      primary_key :id
      foreign_key :owner_id, :providers

      String      :title, null: false
      String      :description
      Array       :tags

      DateTime :created_at
      DateTime :updated_at
    end
  end
end