# frozen_string_literal: true

module HeadlineConnector
    module Response
      # Topic for response
      TopicResponse = Struct.new(:keyword, :related_videos_ids)
    end
  end