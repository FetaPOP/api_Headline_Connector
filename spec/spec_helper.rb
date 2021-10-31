# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

require 'yaml'

require 'minitest/autorun'
require 'minitest/rg'
require 'vcr'
require 'webmock'

require_relative '../init'

VIDEO_ID = 'cmSbXsFE3l8'
CONFIG = YAML.safe_load(File.read('config/secrets.yml'))
YOUTUBE_TOKEN = CONFIG['YOUTUBE_TOKEN']
CORRECT = YAML.safe_load(File.read('spec/fixtures/youtube_results.yml'))

CASSETTES_FOLDER = 'spec/fixtures/cassettes'
CASSETTE_FILE = 'youtube_api'