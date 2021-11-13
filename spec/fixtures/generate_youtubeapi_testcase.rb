# frozen_string_literal: true

require 'http'
require 'yaml'
require 'pry'

config = YAML.safe_load(File.read('config/secrets.yml'))
yt_api_key = config['test']['YOUTUBE_TOKEN']
def yt_api_path(path)
  "https://www.googleapis.com/youtube/v3/#{path}"
end

def call_yt_api(url)
  HTTP.headers('Accept' => 'application/json').get(url)
end

yt_response = {}
yt_results = Array.new

## Save information be index
def save_info_from_video(video, index)
  yt_attr = {
  "index" => index,
  "id" => video['items'][0]['id'], # should be "mSbXsFE3l8"
  "title" => video['items'][0]['snippet']['title'], # Should be "Anna Kendrick - Cups ..."
  "description" => video['items'][0]['snippet']['description'], # Should be the description of this song
  "tags" => video['items'][0]['snippet']['tags'], # Should be an array of tags
  "channelTitle" => video['items'][0]['snippet']['channelTitle'], # should be "AnnaKendrickVEVO"
  "channelId" => video['items'][0]['snippet']['channelId'] # Should be "UCgqabVNmn6dTr66Oy_LP_VA"
  }
end

## Use video function to get tags and other information
def request_video_info_by_id(yt_video_id, yt_api_key)
  yt_video_url = yt_api_path("videos?part=snippet&id=#{yt_video_id}&key=#{yt_api_key}")
  call_yt_api(yt_video_url).parse
end

## the expected amount of search results
max_results = 5

## the search query
q = "surfing"
q_hash = {
  "keyword" => q
}
yt_results.push(q_hash)

## HAPPY video request
## Search_result request
yt_video_url = yt_api_path("search?part=snippet&maxResults=#{max_results}&q=#{q}&key=#{yt_api_key}")
search_result = call_yt_api(yt_video_url).parse # search_result should be a hash

## Video request
items = search_result['items']
items.each_with_index do |var, index|
  video_id = var["id"]["videoId"]
  video_content = request_video_info_by_id(video_id, yt_api_key)
  yt_results_hash = save_info_from_video(video_content, index)
  yt_results.push(yt_results_hash)
end

File.write('spec/fixtures/youtube_results.yml', yt_results.to_yaml)
# File.open("youtube_results_5_video.yml", "w") {|f| f.write(yt_results.to_yaml) }