# frozen_string_literal: true

# Page object for home page
class HomePage
    include PageObject
  
    page_url HeadlineConnector::App.config.APP_HOST
  
    div(:warning_message, id: 'flash_bar_danger')
    div(:success_message, id: 'flash_bar_success')
  
    h1(:title_heading, id: 'main_header')
    text_field(:topic_input, id: 'topic_input')
    button(:add_button, id: 'repo-form-submit')

    def add_new_topic(remote_url)
      self.topic_input = remote_url
      self.add_button
    end

  end
  