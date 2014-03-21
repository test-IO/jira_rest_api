module JiraRestApi
  module Resource

    class UserFactory < JiraRestApi::BaseFactory # :nodoc:
    end

    class User < JiraRestApi::Base
      def self.singular_path(client, key, prefix = '/')
        collection_path(client, prefix) + '?username=' + key
      end
    end

  end
end
