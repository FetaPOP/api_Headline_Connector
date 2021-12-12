# frozen_string_literal: true

require 'roda'
require 'figaro'
require 'sequel'
require 'delegate' # needed until Rack 2.3 fixes delegateclass bug

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
      require 'pry'; # for breakpoints
      puts "db file should be at: #{ENV['DB_FILENAME']}"
      ENV['DATABASE_URL'] = "sqlite://#{config.DB_FILENAME}"
      puts "connecting to: #{ENV['DATABASE_URL']}"
    end

    configure :app_test do
      require_relative '../spec/helpers/vcr_helper.rb'
      VcrHelper.setup_vcr
      VcrHelper.configure_vcr_for_youtube(recording: :none)
    end

    # Database Setup
    DB = Sequel.connect(ENV['DATABASE_URL'])
    def self.DB() = DB # rubocop:disable Naming/MethodName
  end
end
