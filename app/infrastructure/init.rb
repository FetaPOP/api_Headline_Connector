# frozen_string_literal: true

folders = %w[youtube nytimes database messaging cache]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end
