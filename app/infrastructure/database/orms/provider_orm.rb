# frozen_string_literal: true

require 'sequel'

module HeadlineConnector
  module Database
    # Object Relational Mapper for Feed Entities
    class ProviderOrm < Sequel::Model(:providers)
      one_to_many :feeds,
                  class: :'HeadlineConnector::Database::FeedOrm',
                  key: :owner_id
                  
      plugin :timestamps, update_on_create: true

      def self.find_or_create(provider_info) # provider_info should be a hash
        first(provider_title: provider_info[:provider_title]) || create(provider_info)
      end
    end
  end
end
