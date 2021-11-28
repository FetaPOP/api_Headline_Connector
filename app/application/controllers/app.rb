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
        # Get cookie viewer's previously viewed topics
        session[:watching] ||= []

        # Load previously viewed topics
        result = Service::ListTopics.new.call(session[:watching])

        if result.failure?
          flash[:error] = result.failure
          viewable_topics = []
        else
          topics = result.value!
          if topics.none?
            flash.now[:notice] = 'Insert a keyword to get started'
          end

          session[:watching] = topics.map(&:keyword)
          viewable_topics = Views::TopicsList.new(topics)
        end

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
            session[:watching] ||= []

            result = Service::GenerateTextCloud.new.call(
              watched_list: session[:watching],
              keyword: keyword
            )

            if result.failure?
              flash[:error] = result.failure
              routing.redirect '/'
            end

            request_feeds = result.value!

            # Show viewer the topic
            # Need to change to view object
            view 'topic', locals: { keyword: request_feeds[:keyword], text_cloud_stats: request_feeds[:textcloud].text_cloud_stats }  

          end        
        end
      end
    end
  end
end
