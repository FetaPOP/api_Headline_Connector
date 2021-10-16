# frozen_string_literal: true

module HeadlineConnector
  # Model for Channel
  class Channel
    def initialize(channel_data)
      @channel = channel_data
    end

    def title
      @channel['items']['snippet']['channelTitle']
    end

    def id
      @channel['items']['snippet']['channelId']
    end
  end
end
