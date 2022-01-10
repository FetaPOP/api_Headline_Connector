# frozen_string_literal: true

module HeadlineConnector
  module NYTimes
        # Youtube Mapper: YoutubeApi -> Topic entity
        class HeadlinesMapper
            def initialize(api_key, gateway_class = NYTimes::Api)
                @api_key = api_key
                @gateway_class = gateway_class
                @gateway = @gateway_class.new(@api_key)
            end
            
            def request_headlines(period = 1)
                data = @gateway.request_headlines(period)
                build_entity(data)
            end

            def build_entity(data)
                DataMapper.new(data).build_entity
            end
        end

        # Extracts entity specific elements from youtube-returned data structures
        class DataMapper
            def initialize(data)
                @data = data
            end

            def build_entity
                headlines = results.map do |result|
                    HeadlineConnector::Entity::Headline.new(
                        id: nil,
                        article_url: result['url'],
                        section: result['section'],
                        tag: extracts_first_tag(result),
                        title: result['title'],
                        abstract: result['abstract'],
                        img: extracts_media_metadata(result)
                    )
                end

                headlines.reject! do |headline|
                    # We don't want US local news from "New York Times"
                    headline.section == "New York" || headline.section == "U.S."
                end

                HeadlineConnector::Entity::Headlines.new(
                    id: nil,
                    headlines: headlines
                )
            end

            def extracts_media_metadata(article)
                return nil if article['media'].empty?

                article['media'][0]['media-metadata'].each do |a_metadata|
                    return a_metadata['url'] if a_metadata['height'] == 293
                end

                # if no height==293 image found, return the first image
                return result['media'][0]['media-metadata'][0]['url']
            end

            def extracts_first_tag(article)
                article['adx_keywords'].split(';')[0]
            end

            def results
                @data['results']
            end
        end
    end
end