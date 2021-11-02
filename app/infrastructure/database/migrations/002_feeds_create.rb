# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:feeds) do
      primary_key :id

      String      :title, null: false
      String      :description
      Array       :tags
      String      :provider, null: false

      DateTime :created_at
      DateTime :updated_at
    end
  end
end