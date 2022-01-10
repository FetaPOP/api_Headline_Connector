# frozen_string_literal: true

require 'dry/transaction'

module HeadlineConnector
  module Service
    # Transactions to generate headline cluster from New Youk Times API
    class GenerateHeadlineCluster
      include Dry::Transaction

      step :request_headline_cluster_calculation

      private

      HEADLINE_CLUSTER_GENERATING_FAIL_MSG = 'Failed at generating headline cluster'
      HEADLINE_CLUSTER_GENERATING_ERR_MSG = 'Having some troubles generating headline cluster'

      def request_headline_cluster_calculation(input)
        input[:headline_cluster] = Mapper::HeadlineClusterMapper.new().generate_headline_cluster

        if input[:headline_cluster]
          Success(Response::ApiResult.new(status: :ok, message: input[:headline_cluster]))
        else 
          Failure(Response::ApiResult.new(status: :internal_error, message: HEADLINE_CLUSTER_GENERATING_FAIL_MSG))
        end

      rescue StandardError => error
        puts error.backtrace.join("\n")
        Failure(Response::ApiResult.new(status: :internal_error, message: HEADLINE_CLUSTER_GENERATING_ERR_MSG))
      end
    end
  end
end
