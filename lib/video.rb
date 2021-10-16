# frozen_string_literal: true

require_relative 'channel'

module HeadlineConnector
  # Model for Project
  class Video
    def initialize(video_data, data_source)
      @video = video_data
      @data_source = data_source
    end

    def id
        @video['items']['id']
    end

    def title
        @video['items']['snippet']['title']
    end

    def description
        @video['items']['snippet']['description']
    end

    def tags #should change
        @video['items']['snippet']['tags'].each
    end

    def channel
      @channel ||= @data_source.channel(@video['channel'])
    end
  end
end

