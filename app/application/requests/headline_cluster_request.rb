# frozen_string_literal: true

module HeadlineConnector
  module Request
    # Application value for the path of a requested topic
    class HeadlineClusterRequest
      def initialize(request)
        @request = request
      end
    end
  end
end
