module Views
    # View for a single contributor
    class Topic
      def initialize(topic)
        @topic = topic
      end
  
      def entity
        @topic
      end
  
      def id
        @topic.id
      end

      def related_videos_ids
        @topic.related_videos_ids
      end

    end
  end