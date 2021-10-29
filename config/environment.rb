# frozen_string_literal: true

require 'roda'
require 'yaml'

module HeadlineConnector
  # Configuration for the App
  class App < Roda
    CONFIG = YAML.safe_load(File.read('config/secrets.yml'))
    YOUTUBE_TOKEN = CONFIG['YOUTUBE_TOKEN']
  end
end