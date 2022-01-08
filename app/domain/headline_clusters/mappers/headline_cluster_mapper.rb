# frozen_string_literal: true

module HeadlineConnector
    module Mapper
        class HeadlineClusterMapper
            def initialize(period = 1)
                @headlines_entity = NYTimes::HeadlinesMapper.new(App.config.NYTIMES_TOKEN).request_headlines(period)
            end
            
            def generate_headline_cluster
                sorted_by_sections = Value::HeadlineCluster.sort_by_sections(@headlines_entity)
                build_entity(sorted_by_sections)
            end

            def build_entity(sorted_by_sections)
                # sorted_by_sections is a Hash
                Entity::HeadlineCluster.new(id: nil, sections: sorted_by_sections)
            end
        end
    end
end