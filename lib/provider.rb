# frozen_string_literal: true

module HeadlineConnector
  # Model for Provider
  class Provider
    def initialize(provider_data)
      @provider = provider_data
    end

    def id
      @provider['items'][0]['snippet']['channelId']
    end

    def title
      @provider['items'][0]['snippet']['channelTitle']
    end
  end
end
