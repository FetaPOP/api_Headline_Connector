# frozen_string_literal: true

require 'http'
require_relative 'video'
require_relative 'channel'

module HeadlineConnector
  # Library for Github Web API
  class YoutubeApi
    API_PROJECT_ROOT = 'https://youtube.googleapis.com/youtube/v3/'
    module Errors
      class NotFound < StandardError; end
      class Unauthorized < StandardError; end # rubocop:disable Layout/EmptyLineBetweenDefs
    end

    HTTP_ERROR = {
      401 => Errors::Unauthorized,
      404 => Errors::NotFound
    }.freeze

    def initialize(api_key)
      @api_key = api_key
    end

    def data_collect(id)
      req_url = yt_path(id)
      data = call_yt_url(req_url).parse
    end

    def video(data)
      Video.new(data, self)
    end

    def channel(data)
      Channel.new(data, self)
    end

    private

    def yt_path(path)
      "#{API_PROJECT_ROOT}videos?part=snippet&id=#{path}&key=#{@api_key}"
    end

    def call_yt_url(url)
      result =
        HTTP.headers('Accept' => 'application/json')
            .get(url)
      successful?(result) ? result : raise(HTTP_ERROR[result.code])
    end

    def successful?(result)
      !HTTP_ERROR.keys.include?(result.code)
    end
  end
end

