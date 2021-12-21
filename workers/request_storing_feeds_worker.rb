# frozen_string_literal: true

require_relative '../init'

require 'figaro'
require 'shoryuken'

# Shoryuken worker class to clone repos in parallel
class VideoListWorker
  # Environment variables setup
  Figaro.application = Figaro::Application.new(
    environment: ENV['RACK_ENV'] || 'development',
    path: File.expand_path('config/secrets.yml')
  )
  Figaro.load
  def self.config() = Figaro.env

  Shoryuken.sqs_client = Aws::SQS::Client.new(
    access_key_id: config.AWS_ACCESS_KEY_ID,
    secret_access_key: config.AWS_SECRET_ACCESS_KEY,
    region: config.AWS_REGION
  )

  include Shoryuken::Worker
  shoryuken_options queue: config.CLONE_QUEUE_URL, auto_delete: true

  def perform(_sqs_msg, request)
    topic_entity = HeadlineConnector::Representer::Topic
      .new(OpenStruct.new).from_json(request)

    topic_entity.related_videos_ids.each do |video_id|
      if (feed_entity = find_feed_id_in_database(video_id))
        feed_entity
      else
        youtube_feed_entity = request_video_from_youtube(video_id)
        store_feed_to_database(youtube_feed_entity)
      end
    end
  rescue StandardError
    puts error.backtrace.join("\n")
    raise SEARCH_STORE_ERR_MSG
  end
  
  def find_feed_id_in_database(video_id)
    HeadlineConnector::Repository::For.klass(Entity::Feed).find_feed_id(video_id)
  rescue StandardError
    raise FIND_FEEDID_DB_ERR_MSG 
  end

  def request_video_from_youtube(video_id)
    HeadlineConnector::Youtube::FeedMapper.new(App.config.YOUTUBE_TOKEN).request_video(video_id)
  rescue StandardError
    raise YT_REQ_ERR_MSG
  end

  def store_feed_to_database(youtube_feed_entity)
    HeadlineConnector::Repository::For.klass(Entity::Feed).create(youtube_feed_entity)
  rescue StandardError
    raise STORE_FEED_TO_DB_ERR_MSG
  end
end
