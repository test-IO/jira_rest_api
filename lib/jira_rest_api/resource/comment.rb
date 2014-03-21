module JiraRestApi
  module Resource

    class CommentFactory < JiraRestApi::BaseFactory # :nodoc:
    end

    class Comment < JiraRestApi::Base
      belongs_to :issue

      nested_collections true
    end

  end
end
