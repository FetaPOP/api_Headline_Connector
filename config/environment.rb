# frozen_string_literal: true

require 'roda'
require 'figaro'
require 'sequel'
require 'delegate' # needed until Rack 2.3 fixes delegateclass bug
require 'rack/cache'
require 'redis-rack-cache'

module HeadlineConnector
  # Environment-specific configuration
  class App < Roda
    plugin :environments # This plugin comes from Roda

    # Environment variables setup
    Figaro.application = Figaro::Application.new(
      environment: environment,
      path: File.expand_path('config/secrets.yml')
    )
    Figaro.load
    def self.config() = Figaro.env

    configure :development, :test , :app_test do
      ENV['DATABASE_URL'] = "sqlite://#{config.DB_FILENAME}"
    end

    configure :development do
      use Rack::Cache,
          verbose: true,
          metastore: 'file:_cache/rack/meta',
          entitystore: 'file:_cache/rack/body'
    end

    configure :production do
      puts 'RUNNING IN PRODUCTION MODE'
      # Set DATABASE_URL environment variable on production platform
      ENV['DATABASE_URL'] = "postgres://#{config.DB_FILENAME}"

      use Rack::Cache,
          verbose: true,
          metastore: config.REDISCLOUD_URL + '/0/metastore',
          entitystore: config.REDISCLOUD_URL + '/0/entitystore'
    end

    configure :app_test do
      require_relative '../spec/helpers/vcr_helper'
      VcrHelper.setup_vcr
      VcrHelper.configure_vcr_for_youtube(recording: :none)
    end

    # Database Setup
    DB = Sequel.connect(ENV['DATABASE_URL'])
    def self.DB() = DB # rubocop:disable Naming/MethodName
  end
end
