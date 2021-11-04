# frozen_string_literal: true

require 'sequel'

module HeadlineConnector
  module Database
    # Object Relational Mapper for Feed Entities
    class FeedOrm < Sequel::Model(:feeds)
      many_to_one :provider,
                  class: :'HeadlineConnector::Database::ProviderOrm'
      plugin :timestamps, update_on_create: true
    end
  end
end
