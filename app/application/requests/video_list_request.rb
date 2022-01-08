# frozen_string_literal: true

module HeadlineConnector
  module Request
    # Application value for the path of a requested video list
    class VideoListRequest
      def initialize(keyword, request)
        @keyword = keyword
        @request = request
      end

      attr_reader :keyword
    end
  end
end
