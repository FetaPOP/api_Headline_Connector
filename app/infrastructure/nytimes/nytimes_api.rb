# frozen_string_literal: true

require 'http'

module HeadlineConnector
  module NYTimes
    # Client Library for NYTimes API
    class Api
      NYT_API_HEADLINE_ROOT = 'https://api.nytimes.com/svc/mostpopular/v2'

      def initialize(api_key)
        @api_key = api_key
      end

      def request_headlines(period = 1)
        Request.new(NYT_API_HEADLINE_ROOT, @api_key).request_headlines(period).parse
      end

      # Sends out HTTP requests to NYTimes
      class Request
        def initialize(resource_root, api_key)
          @resource_root = resource_root
          @api_key = api_key
        end

        def get(url)
          http_response = HTTP.headers('Accept' => 'application/json').get(url)

          Response.new(http_response).tap do |response|
            raise(response.error) unless response.successful?
          end
        end

        def request_headlines(period)
          get("#{NYT_API_HEADLINE_ROOT}/viewed/#{period}.json?api-key=#{@api_key}")
        end
      end

      # Decorates HTTP responses from Youtube with success/error
      class Response < SimpleDelegator
        BadToken = Class.new(StandardError)
        Unauthorized = Class.new(StandardError)
        NotFound = Class.new(StandardError)

        HTTP_ERROR = {
          400 => BadToken,
          401 => Unauthorized,
          404 => NotFound
        }.freeze

        def successful?
          !HTTP_ERROR.keys.include?(code)
        end

        def error
          HTTP_ERROR[code]
        end
      end
    end
  end
end