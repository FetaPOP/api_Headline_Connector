# frozen_string_literal: true

# Page object for home page
class ProjectPage
  include PageObject

  page_url HeadlineConnector::App.config.APP_HOST +
           '/project/<%=params[:owner_name]%>/<%=params[:project_name]%>' \
           '<%=params[:folder] ? "/#{params[:folder]}" : ""%>'

  div(:warning_message, id: 'flash_bar_danger')
  div(:success_message, id: 'flash_bar_success')

  table(:textcloud_table, id: 'textcloud_table')
end
