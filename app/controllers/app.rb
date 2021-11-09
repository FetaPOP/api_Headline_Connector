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
        feeds = Repository::For.klass(Entity::Feed).all
        view 'home', locals: { feeds: feeds }
      end

      routing.on 'feed' do
        routing.is do
          # POST /feed/
          routing.post do
            yt_url = routing.params['youtube_url']
            routing.halt 400 unless (yt_url.include? 'youtube.com') &&
                                    (yt_url.include? 'v=') &&
                                    (yt_url.split('/').count >= 3)
            video_info = yt_url.split('/')[-1]
            video_id = extract_video_id(video_info)

            # Get a video from Youtube
            feed = Youtube::FeedtMapper
              .new(App.config.YOUTUBE_TOKEN)
              .find(video_id)

            # Add feed to database
            Repository::For.entity(feed).create(feed)

            # Redirect viewer to the corresponding feed page
            routing.redirect "feed/#{feed.feed_id}"
          end
        end

        routing.on String do |video_id|
          # GET /feed/#{video_id}
          routing.get do
            # Get project from database (not from Youtube API anymore)
            youtube_video = Repository::For.klass(Entity::Feed)
              .find_feed_id(video_id)

            # Show viewer the project
            view 'feed', locals: { feed: youtube_video }
          end
        end
      end
    end

    def extract_video_id(video_info)
      video_info.split('?').each do |parsed_video_info|
        parsed_video_info.split('&').each do |attribute|
          return attribute.split('=')[1] if attribute.include? 'v='
        end
      end
    end
  end
end
