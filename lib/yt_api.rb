# frozen_string_literal: true

require 'http'
require_relative 'feed'
require_relative 'provider'

module HeadlineConnector
  # Library for Github Web API
  class YoutubeApi
    API_PROJECT_ROOT = 'https://youtube.googleapis.com/youtube/v3/'
    module Errors
      class BadToken < StandardError; end

      class NotFound < StandardError; end

      class Unauthorized < StandardError; end
    end

    HTTP_ERROR = {
      400 => Errors::BadToken,
      401 => Errors::Unauthorized,
      404 => Errors::NotFound
    }.freeze

    def initialize(api_key)
      @api_key = api_key
    end

    def collect_data(id)
      req_url = yt_path(id)
      call_yt_url(req_url).parse
    end

    private

    def yt_path(id)
      "#{API_PROJECT_ROOT}videos?part=snippet&id=#{id}&key=#{@api_key}"
    end

    def call_yt_url(url)
      result = HTTP.headers('Accept' => 'application/json').get(url)
      successful?(result) ? result : raise(HTTP_ERROR[result.code])
    end

    def successful?(result)
      !HTTP_ERROR.keys.include?(result.code)
    end
  end
end
