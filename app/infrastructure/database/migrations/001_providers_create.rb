# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:providers) do
      primary_key :id

      String      :provider_id, unique: true
      String      :provider_title

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
