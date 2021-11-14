# frozen_string_literal: true

require 'roda'
require 'slim'

module HeadlineConnector
  # Web App
  class App < Roda
    plugin :render, engine: 'slim', views: 'app/views'
    plugin :public, root: 'app/views/public'
    plugin :assets, path: 'app/views/assets',
                    css: 'style.css', js: 'table_row_click.js'
    plugin :halt

    route do |routing|
      routing.assets # load CSS
      routing.public

      # GET /
      routing.root do # rubocop:disable Metrics/BlockLength
        feeds = Repository::For.klass(Entity::Topic).all
        view 'home', locals: { feeds: feeds }
      end

      routing.on 'topic' do
        routing.is do
          # POST /topic/
          routing.post do
            keyword = routing.params['keyword']
            routing.halt 400 unless (!keyword.empty?)

            # Fetch related videos ids from Youtube Api
            topic = Youtube::TopicMapper
              .new(App.config.YOUTUBE_TOKEN)
              .search_keyword(keyword)

            # Request related videos info from database or from Youtube Api(if not found in database)
            related_feeds = topic.related_videos_ids.map do |id|
              database_feed = Repository::For.klass(Entity::Feed).find_feed_id(id)
              if database_feed # Found in database, build a feed entity
                return database_feed                
              else # not found in database, request from Youtube Api and build a feed entity
                youtube_feed = Youtube::FeedMapper
                  .new(App.config.YOUTUBE_TOKEN)
                  .request_video(id)

                # Save to database
                Repository::For.klass(Entity::Feed).create(youtube_feed)

                return youtube_feed
              end
            end
            
            textcloud = Mapper::TextCloudMapper
              .new(related_feeds)
              .generate_textcloud

            # Show viewer the project
            view 'textcloud', locals: { textcloud: textcloud}
          end
        end
      end
    end
  end
end
