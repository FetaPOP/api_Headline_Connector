# frozen_string_literal: true

require 'rake/testtask'

CODE = 'lib/'

task :default do
  puts `rake -T`
end

desc 'run tests'
  task :spec do
    sh 'ruby spec/gateway_youtube_spec.rb'
  end

desc 'Keep rerunning tests upon changes'
task :respec do
  sh "rerun -c 'rake spec' --ignore 'coverage/*'"
end

desc 'Rerunning rackup services upon changes'
task :rerack do
  sh "rerun -c rackup --ignore 'coverage/*'"
end

desc 'run tests after deleting all VCR cassettes files'
task :clean_spec do
  sh 'rm spec/fixtures/cassettes/*.yml' do |ok, _|
    puts(ok ? 'Cassettes deleted' : 'No cassettes found')
  end
  sh 'ruby spec/gateway_youtube_spec.rb'
end

desc 'Generate the correct answer for tests'
task :correct_for_spec do
  sh "ruby spec/fixtures/project_info.rb"
end

namespace :vcr do
  desc 'delete cassette fixtures'
  task :wipe do
    sh 'rm spec/fixtures/cassettes/*.yml' do |ok, _|
      puts(ok ? 'Cassettes deleted' : 'No cassettes found')
    end
  end
end

namespace :quality do
  only_app = 'config/ app/'

  desc 'run all static-analysis quality checks'
  task all: %i[rubocop flog reek]

  desc 'code style linter'
  task :rubocop do
    sh 'rubocop'
  end

  desc 'code smell detector'
  task :reek do
    sh 'reek'
  end

  desc 'complexiy analysis'
  task :flog do
    sh "flog -m #{only_app}"
  end
end
