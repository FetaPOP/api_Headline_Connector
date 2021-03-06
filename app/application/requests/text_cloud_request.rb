# frozen_string_literal: true

module HeadlineConnector
  module Request
    # Application value for the path of a requested textcloud
    class TextCloudRequest
      def initialize(keyword, request)
        @keyword = keyword
        @request = request
      end

      attr_reader :keyword
    end
  end
end
