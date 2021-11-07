# frozen_string_literal: true

require 'roda'
require 'slim'

module HeadlineConnector
  # Web App
  class App < Roda
    plugin :render, engine: 'slim', views: 'app/views'
    plugin :assets, css: 'style.css', path: 'app/views/assets'
    plugin :halt

    route do |routing|
      routing.assets # load CSS

      # GET /
      routing.root do
        view 'home'
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

            routing.redirect "feed/#{video_id}"
          end
        end

        routing.on String do |video_id|
          # GET /feed/video_id
          routing.get do
            youtube_video = Youtube::FeedMapper
              .new(YT_TOKEN)
              .find(video_id)

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
