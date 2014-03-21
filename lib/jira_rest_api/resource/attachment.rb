module JiraRestApi
  module Resource

    class AttachmentFactory < JiraRestApi::BaseFactory # :nodoc:
    end

    class Attachment < JiraRestApi::Base
      has_one :author, :class => JiraRestApi::Resource::User
    end

  end
end
