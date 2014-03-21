module JiraRestApi
  module Resource

    class WorklogFactory < JiraRestApi::BaseFactory # :nodoc:
    end

    class Worklog < JiraRestApi::Base
      has_one :author, :class => JiraRestApi::Resource::User
      has_one :update_author, :class => JiraRestApi::Resource::User,
                              :attribute_key => "updateAuthor"
      belongs_to :issue
      nested_collections true
    end

  end
end
