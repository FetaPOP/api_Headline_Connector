# frozen_string_literal: true

require 'roda'
require 'slim'
require 'slim/include'
require_relative 'helpers.rb'

module HeadlineConnector
  # Web App
  class App < Roda
    include RouteHelpers

    plugin :halt
    plugin :flash
    plugin :all_verbs # recognizes HTTP verbs beyond GET/POST (e.g., DELETE)
    plugin :render, engine: 'slim', views: 'app/presentation/views_html'
    plugin :assets, path: 'app/presentation/assets',
                    css: 'style.css', js: 'table_row_click.js'
                    
    use Rack::MethodOverride # for other HTTP verbs (with plugin all_verbs)

    route do |routing|
      routing.assets # load CSS
      routing.public

      # GET /
      routing.root do # rubocop:disable Metrics/BlockLength
        # feeds = Repository::For.klass(Entity::Topic).all
        # view 'home', locals: { feeds: feeds }

        # Get cookie viewer's previously viewed topics
        session[:watching] ||= []

        # Load previously viewed topics
        topics = Repository::For.klass(Entity::Topic)
          .find_topic_names(session[:watching])

        session[:watching] = topics.map(&:keyword)

        if topics.none?
          flash.now[:notice] = 'Insert a keyword to get started'
        end

        viewable_topics = Views::TopicsList.new(topics)

        view 'home', locals: { topics: viewable_topics }
      end

      routing.on 'topic' do
        routing.is do
          # POST /topic/
          routing.post do
            keyword = Forms::NewTopic.new.call(routing.params)
            topic_made = Service::AddTopic.new.call(keyword)
            
            if topic_made.failure?
              flash[:error] = topic_made.failure
              routing.redirect '/'
            end

            topic = topic_made.value!
            # Add new topic to watched set in cookies (wip)
            session[:watching].insert(0, topic).uniq!
            # Redirect viewer to search page
            flash[:notice] = 'Topic added to your list'
            routing.redirect "topic/#{keyword}"

          end
        end
        
        routing.on String do |keyword|
          # GET /topic/{keyword}
          routing.get do
            # Request related videos info from database or from Youtube Api(if not found in database)
            topic = Youtube::TopicMapper
              .new(App.config.YOUTUBE_TOKEN)
              .search_keyword(keyword)
            related_feeds = topic.related_videos_ids.map do |video_id|
              # Found in database, build a feed entity and go into next
              begin 
                database_feed = Repository::For.klass(Entity::Feed)
                  .find_feed_id(video_id)
                next database_feed if database_feed
              rescue StandardError
                flash[:error] = 'Video not found'
                routing.redirect '/'
              end

              # not found in database, request from Youtube Api and build a feed entity
              begin 
                youtube_feed = Youtube::FeedMapper
                  .new(App.config.YOUTUBE_TOKEN)
                  .request_video(video_id)
              rescue StandardError
                flash[:error] = 'Having trouble accessing Youtube'
                routing.redirect '/'
              end

              # Save new feeds to database
              begin
                Repository::For.klass(Entity::Feed).create(youtube_feed) if youtube_feed.feed_id
                youtube_feed
              rescue StandardError => err
                flash[:error] = 'Having trouble accessing the database'
              end
            end

            textcloud = Mapper::TextCloudMapper.new(related_feeds).generate_textcloud

            # Show viewer the topic
            view 'topic', locals: { keyword: keyword, text_cloud_stats: textcloud.text_cloud_stats }  
          end        
        end
      end
    end
  end
end
