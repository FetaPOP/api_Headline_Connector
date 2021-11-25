# frozen_string_literal: true

require 'dry-validation'

module HeadlineConnector
  module Forms
    class NewTopic < Dry::Validation::Contract
      URL_REGEX = %r{(http[s]?)\:\/\/(www.)?youtube\.com\/.*\/.*(?<!git)$}.freeze

      params do
        required(:remote_url).filled(:string)
      end

      rule(:remote_url) do
        unless URL_REGEX.match?(value)
          key.failure('is an invalid address for a Youtube search')
        end
      end
    end
  end
end
