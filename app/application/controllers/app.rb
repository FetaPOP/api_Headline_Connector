# frozen_string_literal: true

require 'roda'

module HeadlineConnector
  # Web App
  class App < Roda
    plugin :halt
    plugin :flash
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
            # POST api/v1/topic/{keyword}
            routing.post do
              add_topic_request = Request::TopicRequest.new(keyword, request)
              topic_entity_result = Service::AddTopic.new.call(requested: add_topic_request)
              
              if topic_entity_result.failure?
                failed = Representer::HttpResponse.new(topic_entity_result.failure)
                routing.halt failed.http_status_code, failed.to_json
              end 

              response.status = Representer::HttpResponse.new(topic_entity_result.value!).http_status_code

              Representer::Topic.new(topic_entity_result.value!.message).to_json
            end
          end
        end

        routing.on 'textcloud' do
          routing.on String do |keyword|
            # GET api/v1/textcloud/{keyword}
            routing.get do
              generate_textcloud_request = Request::TextCloudRequest.new(keyword, request)
              result = Service::GenerateTextCloud.new.call(requested: generate_textcloud_request)

              if result.failure?
                failed = Representer::HttpResponse.new(result.failure)
                routing.halt failed.http_status_code, failed.to_json
              end         

              response.status = Representer::HttpResponse.new(result.value!).http_status_code

              Representer::TextCloud.new(result.value!.message).to_json
            end
          end        
        end

        routing.on 'articles' do
          routing.get do
            ['Government','State', 'covid', 'usa'].to_json
          end
        end
      end
    end
    # rubocop:enable Metrics/BlockLength
  end
end