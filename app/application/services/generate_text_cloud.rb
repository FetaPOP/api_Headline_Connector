# frozen_string_literal: true

require 'dry/transaction'

module HeadlineConnector
  module Service
    # Analyzes contributions to a project
    class GenerateTextCloud
      include Dry::Transaction

      step :ensure_watched_topic
      step :retrieve_topic
      step :request_videos
      step :generate_text_cloud

      private

      def ensure_watched_topic(input)
        if input[:watched_list].include? input[:requested]
          Success(input)
        else
          Failure('Please first request this topic to be added to your list')
        end
      end

      def retrieve_topic(input)
        input[:topic] = Repository::For.klass(Entity::Topic).find_topic_name(input[:keyword])

        input[:topic] ? Success(input) : Failure('Topic not found')

      rescue StandardError
        Failure('Having trouble accessing the database')
      end

      def request_videos(input)
        input[:related_feeds] = input[:topic].related_videos_ids.map do |video_id|
          if (feed = feed_in_database(video_id))
            feed
          else
            youtube_feed = feed_from_youtube(video_id)
            store_feed(youtube_feed)
          end
        end

        Success(input)
        
      rescue StandardError => error
          Failure(error.to_s)
      end

      def generate_text_cloud(input)
          input[:textcloud] = Mapper::TextCloudMapper.new(input[:related_feeds]).generate_textcloud
    
          input[:textcloud] ? Success(input) : Failure('No textcloud')
      rescue StandardError
        Failure('Having trouble generateing textcloud')
      end

      # following are support methods that other services could use

      def feed_in_database(video_id)
        # Found in database, build a feed entity and go into next
        database_feed = Repository::For.klass(Entity::Feed).find_feed_id(video_id)
        return database_feed if database_feed
      end

      def feed_from_youtube(video_id)
        # not found in database, request from Youtube Api and build a feed entity
        Youtube::FeedMapper.new(App.config.YOUTUBE_TOKEN).request_video(video_id)
      rescue StandardError
        raise 'Having trouble accessing Youtube'
      end

      def store_feed(youtube_feed)
        # Save new feeds to database
        Repository::For.klass(Entity::Feed).create(youtube_feed) if youtube_feed.feed_id
        youtube_feed
      rescue StandardError
        raise 'Having trouble accessing the database'
      end
    end
  end
end



            
