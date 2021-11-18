module Views
    # View for a single contributor
    class Provider
      def initialize(provider)
        @provider = provider
      end
  
      def entity
        @provider
      end
  
      def id
        @provider.id
      end

      def provider_id
        @provider.provider_id
      end

      def provider_title
        @provider.provider_title
      end
  
    end
  end