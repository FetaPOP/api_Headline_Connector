# frozen_string_literal: true

require_relative 'channel'

module HeadlineConnector
  # Model for Video
  class Video

    def initialize(video_data)
      @video = video_data
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
      @video['items'][0]['snippet']['tags']
    end

    def channel
      @video['items'][0]['snippet']['channelTitle']
    end
  end
end
