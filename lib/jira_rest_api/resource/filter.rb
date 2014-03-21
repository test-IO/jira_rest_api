module JiraRestApi
  module Resource
    class FilterFactory < JiraRestApi::BaseFactory # :nodoc:
    end

    class Filter < JiraRestApi::Base
      has_one :owner, :class => JiraRestApi::Resource::User

      # Returns all the issues for this filter
      def issues
        Issue.jql(self.client, self.jql)
      end
    end
  end
end
