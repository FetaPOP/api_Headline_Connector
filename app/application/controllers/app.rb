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
    plugin :assets, path: 'app/presentation/assets', css: 'style.css'
                    
    use Rack::MethodOverride # for other HTTP verbs (with plugin all_verbs)

    route do |routing|
      routing.assets # load CSS

      # GET /
      routing.root do # rubocop:disable Metrics/BlockLength
        # Get cookie viewer's previously viewed topics
        session[:watching] ||= []

        view 'home'
      end

      routing.on 'topic' do
        routing.is do
          # POST /topic/
          routing.post do
            input = Forms::NewTopic.new.call(routing.params)
            topic_entity_result = Service::AddTopic.new.call(input)
          
            if topic_entity_result.failure?
              flash[:error] = topic_entity_result.failure
              routing.redirect '/'
            end

            topic_entity = topic_entity_result.value!

            # Add new topic to watched set in cookies (wip)
            session[:watching].insert(0, topic_entity).uniq!

            # Redirect viewer to their requested page
            flash[:notice] = 'Topic added to your list'
            routing.redirect "topic/#{topic_entity.keyword}"
          end
        end
        
        routing.on String do |keyword|
          # GET /topic/{keyword}
          routing.get do
            # Request related videos info from database or from Youtube Api(if not found in database)
            session[:watching] ||= []

            result = Service::GenerateTextCloud.new.call(keyword: keyword)

            if result.failure?
              flash[:error] = result.failure
              routing.redirect '/'
            end         

            request_feeds = result.value!

            # Show viewer the topic
            # Need to change to topic view object
            view 'topic', locals: { keyword: request_feeds[:keyword], text_cloud: request_feeds[:textcloud] }  

          end        
        end
      end
    end
  end
end
