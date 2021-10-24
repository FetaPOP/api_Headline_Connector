# frozen_string_literal: true

module HeadlineConnector
  # Model for Feed
  class Feed

    def initialize(feed_data)
      @feed = feed_data
    end

    def id
      @feed['items'][0]['id']
    end

    def title
      @feed['items'][0]['snippet']['title']
    end

    def description
      @feed['items'][0]['snippet']['description']
    end

    def tags
      @feed['items'][0]['snippet']['tags']
    end

    def provider
      @feed['items'][0]['snippet']['channelTitle']
    end
  end
end
