# frozen_string_literal: true

require 'time'

module HeadlineConnector
  module Value
    class VideoList < SimpleDelegator
      def self.calculate(related_feeds_array_of_hashes)
        video_list_hash = {
          this_week: [],
          this_month: [],
          this_year: [],
          before_this_year: []
        }

        related_feeds_array_of_hashes.each do |feed_hash|
          published_time = Time.xmlschema(feed_hash[:publishedAt]) # from the required 'time'
          now_time = Time.now.utc

          time_diff_in_days = (now_time - published_time) / (86400)

          if time_diff_in_days <= 7
            video_list_hash[:this_week].push(feed_hash[:feed_id])
          elsif time_diff_in_days <= 30
            video_list_hash[:this_month].push(feed_hash[:feed_id])
          elsif time_diff_in_days <= 365
            video_list_hash[:this_year].push(feed_hash[:feed_id])
          else
            video_list_hash[:before_this_year].push(feed_hash[:feed_id])
          end
        end

        return video_list_hash
      end
    end
  end
end