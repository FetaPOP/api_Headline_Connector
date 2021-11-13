# frozen_string_literal: true

folders = %w[topics feeds]
  folders.each do |folder|
    require_relative "#{folder}/init"
end
