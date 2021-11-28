# frozen_string_literal: true

# Page object for home page
class TopicPage
  include PageObject

  page_url HeadlineConnector::App.config.APP_HOST +
           '/topic/<%=params[:keyword]%>'

  div(:warning_message, id: 'flash_bar_danger')
  div(:success_message, id: 'flash_bar_success')

  table(:textcloud_table, id: 'textcloud_table')
end
