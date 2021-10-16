# frozen_string_literal: true

require_relative 'channel'

module HeadlineConnector
  # Model for Video
  class Video

    attr_accessor :video

    def initialize(video_data, data_source)
      @video = video_data
      @data_source = data_source
    end

    def id
        @video['items'][0]['id']
    end

    def title
        @video['items'][0]['snippet']['title']
    end

    def description
        @video['items'][0]['snippet']['description']
    end

    def tags
        @video['items'][0]['snippet']['tags'].each
    end

    def channel
      @channel ||= @data_source.channel(@video['channel'])
    end
  end
end

