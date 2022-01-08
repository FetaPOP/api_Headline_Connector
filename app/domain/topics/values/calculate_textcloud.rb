# frozen_string_literal: true

module HeadlineConnector
  module Value
    class TextCloud < SimpleDelegator
      def self.calculate(tags_list)
        # tags_hash is the array requires for the text_cloud gem
        tags_hash = Hash.new
        
        # tags will be a list of tags that aggregates from all the feeds' tags
        tags_list.each do |tag|
            tags_hash[tag].nil? ? tags_hash[tag] = 1 : tags_hash[tag] += 1
        end
        
        textcloud_array = Array.new
        tags_hash.each do |keyword, appearTimes|
          next if appearTimes <=5

          a_tag = Hash.new
          a_tag["keyword"] = keyword
          a_tag["appearTimes"] = appearTimes
          textcloud_array.push(a_tag)
        end

        return textcloud_array
      end
    end
  end
end