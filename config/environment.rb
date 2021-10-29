<<<<<<< HEAD
# frozen_string_literal: true

require 'roda'
require 'yaml'

module HeadlineConnector
  # Configuration for the App
  class App < Roda
    CONFIG = YAML.safe_load(File.read('config/secrets.yml'))
    YT_TOKEN = CONFIG['YOUTUBE_TOKEN']
  end
end
=======
# frozen_string_literal: true

require 'roda'
require 'yaml'

module HeadlineConnector
  # Configuration for the App
  class App < Roda
    CONFIG = YAML.safe_load(File.read('config/secrets.yml'))
    YOUTUBE_TOKEN = CONFIG['YOUTUBE_TOKEN']
  end
end
>>>>>>> cd8cd8426ed482b564e2ef60124f2c24f0b4ae7b
