# frozen_string_literal: true

require 'sequel'

module HeadlineConnector
  module Database
    # Object Relational Mapper for Feed Entities
    class ProviderOrm < Sequel::Model(:providers)
      one_to_many :provided_feeds,
                  class: :'HeadlineConnector::Database::FeedOrm',
                  key: :provider_id

      plugin :timestamps, update_on_create: true

      # provider_info should be a hash
      def self.find_or_create(provider_info)
        first(provider_id: provider_info[:provider_id]) || create(provider_info)
      end
    end
  end
end
