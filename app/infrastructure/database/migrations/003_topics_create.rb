# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:topics) do
      primary_key :id

      String      :keyword, unique: true

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
