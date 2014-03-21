require 'jira'
require 'rails'

module JiraRestApi
  class Railtie < Rails::Railtie
    rake_tasks do
      load 'tasks/generate.rake'
    end
  end
end
