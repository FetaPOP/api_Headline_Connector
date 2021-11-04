# frozen_string_literal: true

require 'sequel'

module HeadlineConnector
  module Database
    # Object Relational Mapper for Feed Entities
    class ProviderOrm < Sequel::Model(:providers)
      one_to_many :feeds,
                  class: :'HeadlineConnector::Database::FeedOrm',
                  key: :provider_id
                  
      plugin :timestamps, update_on_create: true

      def self.find_or_create(provider_info)
        first(title: provider_info[:channel_title]) || create(provider_info)
      end
    end
  end
end
