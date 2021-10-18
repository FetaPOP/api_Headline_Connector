# frozen_string_literal: true

module HeadlineConnector
  # Model for Channel
  class Channel
    def initialize(channel_data, data_source)
      @channel = channel_data
      @data_source = data_source
    end

    def channelId
      @channel['items'][0]['snippet']['channelId']
    end

    def channelTitle
      @channel['items'][0]['snippet']['channelTitle']
    end
  end
end
