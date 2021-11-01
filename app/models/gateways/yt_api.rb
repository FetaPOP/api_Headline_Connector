# frozen_string_literal: true

require 'http'

module HeadlineConnector
  module Youtube
  # Client Library for Youtube API
    class Api
      YOUTUBE_PATH = 'https://youtube.googleapis.com/youtube/v3/'.freeze
      def initialize(api_key)
        @api_key = api_key
      end

      def collect_data(id)
        collect_data_response = Request.new(YOUTUBE_PATH, @api_key).video_link(id).parse
      end

      # Sends out HTTP requests to Youtube
      class Request
        def initialize(resource_root, api_key)
          @resource_root = resource_root
          @api_key = api_key
        end

        def video_link(id)
          get(@resource_root + "videos?part=snippet&id=#{id}&key=" + @api_key)
        end

        def get(url)
          http_response = HTTP.headers('Accept' => 'application/json').get(url)

          Response.new(http_response).tap do |response|
            raise(response.error) unless response.successful?
          end
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
          HTTP_ERROR.keys.include?(code) ? false : true
        end

        def error
          HTTP_ERROR[code]
        end
      end
    end
  end
end
