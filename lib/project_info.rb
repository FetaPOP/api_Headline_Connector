# frozen_string_literal: true

require 'http'
require 'yaml'

API_KEY = 'AIzaSyAXaC7TITl7pHR5dp0Si2E_hrFyxNpQTUo'
API_video_ROOT = 'https://youtube.googleapis.com/youtube/v3/'

config = YAML.safe_load(File.read('../config/secrets.yml'))

module Errors
    class NotFound < StandardError; end
    class Unauthorized < StandardError; end # rubocop:disable Layout/EmptyLineBetweenDefs
  end

HTTP_ERROR = {
    401 => Errors::Unauthorized,
    404 => Errors::NotFound
  }.freeze

def yt_api_path(id)
    "#{API_video_ROOT}videos?part=snippet&id=#{id}&key=#{API_KEY}"
end

def call_yt_url(url)
    result =
      HTTP.headers('Accept' => 'application/json').get(url)
#    successful?(result) ? result : raise(HTTP_ERROR[result.code])
end

yt_response = {}
yt_results = {}

## HAPPY video request
video_url = yt_api_path('cmSbXsFE3l8')
yt_response[video_url] = call_yt_url(video_url)
video = yt_response[video_url].parse

yt_results['id'] = video['items'][0]['id']
# should be 

yt_results['title'] = video['items'][0]['snippet']['title']
# should 

yt_results['description'] = video['items'][0]['snippet']['description']
# should be 

yt_results['tags'] = video['items'][0]['snippet']['tags'].each
# should be 

yt_results['channel'] = video['items'][0]['snippet']['channelTitle']
# "should be 
# "should be 

yt_results['channelId'] = video['items'][0]['snippet']['channelId']
# should be 

yt_results['channelTitle'] = video['items'][0]['snippet']['channelTitle']
# "should be 

File.write('../spec/fixtures/youtube_results.yml', yt_results.to_yaml)