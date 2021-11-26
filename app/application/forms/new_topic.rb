# frozen_string_literal: true

require 'dry-validation'

module HeadlineConnector
  module Forms
    class NewTopic < Dry::Validation::Contract
      URL_REGEX = %r{(http[s]?)\:\/\/(www.)?youtube\.com\/.*\/.*(?<!git)$}.freeze

      params do
        required(:keyword).filled(:string)
      end

      rule(:keyword) do
        unless URL_REGEX.match?(value)
          key.failure('is an invalid search for a Youtube')
        end
      end
    end
  end
end
