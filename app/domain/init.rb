# frozen_string_literal: true

folders = %w[topics headline_clusters]
  folders.each do |folder|
    require_relative "#{folder}/init"
end
