# frozen_string_literal: true

require 'roda'
require 'figaro'
require 'sequel'
require 'yaml'

module HeadlineConnector
  # Configuration for the App
  class App < Roda
    plugin :environments # This plugin comes from Roda

    configure do
      # Environment variables setup
      Figaro.application = Figaro::Application.new(
        environment: environment,
        path: File.expand_path('config/secrets.yml')
      )
      Figaro.load
      def self.config() = Figaro.env

      configure :development, :test do # This "configure" function comes from :environments plugin
        ENV['DATABASE_URL'] = "sqlite://#{config.DB_FILENAME}"
      end

      # Database Setup
      DB = Sequel.connect(ENV['DATABASE_URL'])
      def self.DB() = DB # rubocop:disable Naming/MethodName
    end
    # rubocop:enable Lint/ConstantDefinitionInBlock
  end
end
