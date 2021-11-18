module Views
    # View for a single contributor
    class Feed
      def initialize(feed)
        @feed = feed
      end
  
      def entity
        @feed
      end
  
      def id
        @feed.id
      end

      def feed_id
        @feed.feed_id
      end

      def feed_title
        @feed.feed_title
      end

      def description
        @feed.description
      end

      def tags
        @feed.tags
      end

      def provider
        @feed.provider
      end
  
    end
  end