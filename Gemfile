# frozen_string_literal: true

source 'https://rubygems.org'
ruby File.read('.ruby-version').strip

# Configuration and Utilities
gem 'figaro', '~> 1.2'
gem 'rake', '~> 13.0'

# APPLICATION LAYER
# Web application related
gem 'puma', '~> 5.5'
gem 'rack', '~> 2' # 2.3 will fix delegateclass bug
gem 'roda', '~> 3.49'
gem 'slim', '~> 4.1'

# Controllers and services
gem 'dry-monads', '~> 1.4'
gem 'dry-transaction', '~> 0.13'
gem 'dry-validation', '~> 1.7'

# DOMAIN LAYER
# Validation
gem 'dry-struct', '~> 1.4'
gem 'dry-types', '~> 1.5'

# INFRASTRUCTURE LAYER
# Networking
gem 'http', '~> 5.0'

# Database
gem 'hirb'
gem 'hirb-unicode', '~> 0'
gem 'sequel' # Mapper from objects and relational database

group :development, :test do
  gem 'sqlite3', '~> 1.4'
end

group :production do
  gem 'pg', '~> 1.2'
end

# TESTING
group :test do
  gem 'minitest', '~> 5.0'
  gem 'minitest-rg', '~> 5.0'
  gem 'simplecov', '~> 0'
  gem 'vcr', '~> 6.0'
  gem 'webmock', '~> 3.0'
end

group :development do
  gem 'rerun', '~> 0'
end

# DEBUGGING
gem 'pry'

# QUALITY
group :development do
  gem 'flog'
  gem 'reek'
  gem 'rubocop'
end
