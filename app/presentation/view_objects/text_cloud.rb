module Views
    # View for a single contributor
    class TextCloud
      def initialize(text_cloud)
        @text_cloud = text_cloud
      end
  
      def entity
        @text_cloud
      end
  
      def stats
        @text_cloud.stats
      end
  
    end
  end