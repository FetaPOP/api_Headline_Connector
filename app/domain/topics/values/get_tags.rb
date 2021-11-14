module HeadlineConnector
  module Value
    class TextCloud < SimpleDelegator
      def calculate(tags_list)
        # tags_hash is the array requires for the text_cloud gem
        tags_hash = {}  
        
        # tags will be a list of tags that aggregates from all the feeds' tags
        tags_list.each do |tag|
            tags_hash[tag].nil? ? tags_hash[tag] = 1 : tags_hash[tag] += 1
        end
        tags_hash.to_a
      end
    end
  end
end