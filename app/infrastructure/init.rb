# frozen_string_literal: true

folders = %w[youtube database messaging]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end
