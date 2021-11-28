# frozen_string_literal: true

folders = %w[topics]
  folders.each do |folder|
    require_relative "#{folder}/init"
end
