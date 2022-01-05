# frozen_string_literal: true

require 'http'
require 'yaml'
require 'pry'

API_KEY = 'MoMAYD2LtIhgPjSUJfU0ovy6ZGNJ9CCJ'
API_ROOT = 'https://api.nytimes.com/svc/mostpopular/v2'

config = YAML.safe_load(File.read('secrets.yml'))

module Errors
    class NotFound < StandardError; end
    class Unauthorized < StandardError; end # rubocop:disable Layout/EmptyLineBetweenDefs
  end

HTTP_ERROR = {
    401 => Errors::Unauthorized,
    404 => Errors::NotFound
  }.freeze

def nyt_api_path(period)
    "#{API_ROOT}/viewed/#{period}.json?api-key=#{API_KEY}"
end

def call_nyt_url(url)
    http_response = HTTP.headers('Accept' => 'application/json').get(url)
#    successful?(result) ? result : raise(HTTP_ERROR[result.code])
end

nyt_response = {}
nyt_results = {}

## HAPPY video request
article_url = nyt_api_path(period = 1)
nyt_response[article_url] = call_nyt_url(article_url)
article = nyt_response[article_url].parse
File.write('nytimes_results_01.yml', article.to_yaml)