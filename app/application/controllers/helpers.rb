# frozen_string_literal: true

module HeadlineConnector
  module RouteHelpers
    # Application value for the path of a requested topic
    class TopictRequestPath
      def initialize(keyword, request)
        @keyword = keyword
        @request = request
      end

      attr_reader :keyword
    end
  end
end
