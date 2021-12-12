# frozen_string_literal: true

require 'roda'

module HeadlineConnector
  # Web App
  class App < Roda
    plugin :halt
    plugin :caching
    plugin :all_verbs # recognizes HTTP verbs beyond GET/POST (e.g., DELETE)
    use Rack::MethodOverride # for other HTTP verbs (with plugin all_verbs)

    # rubocop:disable Metrics/BlockLength
    route do |routing|
      response['Content-Type'] = 'application/json'

      # GET /
      routing.root do # rubocop:disable Metrics/BlockLength
        message = "HeadlineConnector API v1 at /api/v1/ in #{App.environment} mode"

        result_response = Representer::HttpResponse.new(
          Response::ApiResult.new(status: :ok, message: message)
        )

        response.status = result_response.http_status_code
        result_response.to_json
      end

      routing.on 'api/v1' do
        routing.on 'topics' do
          routing.on String do |keyword|
            # GET /topics/{keyword}
            routing.get do
              response.cache_control public: true, max_age: 10

              # Request related videos info from database or from Youtube Api(if not found in database)
              keyword_request = Request::TopicRequest.new(
                keyword, request
              )
              result = Service::GenerateTextCloud.new.call(requested: keyword_request)

              if result.failure?
                failed = Representer::HttpResponse.new(result.failure)
                routing.halt failed.http_status_code, failed.to_json
              end         

              http_response = Representer::HttpResponse.new(result.value!)
              response.status = http_response.http_status_code

              request_feeds = result.value!

              # Show viewer the topic
              # Need to change to topic view object
              # view 'topic', locals: { keyword: request_feeds[:keyword], text_cloud: request_feeds[:textcloud] }  

              Representer::TopicFeedTextcloud.new(
                result.value!.message
              ).to_json
            end

            # POST /topics/
            routing.post do
              topic_entity_result = Service::AddTopic.new.call(keyword: keyword)
              
              if topic_entity_result.failure?
                failed = Representer::HttpResponse.new(topic_entity_result.failure)
                routing.halt failed.http_status_code, failed.to_json
              end 

              http_response = Representer::HttpResponse.new(topic_entity_result.value!)
              response.status = http_response.http_status_code
              Representer::Topic.new(topic_entity_result.value!.message).to_json
            end
          end
        end
      end
    end
    # rubocop:enable Metrics/BlockLength
  end
end
