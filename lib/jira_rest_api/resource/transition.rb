module JiraRestApi
  module Resource

    class TransitionFactory < JiraRestApi::BaseFactory # :nodoc:
    end

    class Transition < JiraRestApi::Base
      has_one :to, :class => JiraRestApi::Resource::Status
      belongs_to :issue

      nested_collections true

      def self.endpoint_name
        'transitions'
      end

      def self.all(client, options = {})
        issue = options[:issue]
        unless issue
          raise ArgumentError.new("parent issue is required")
        end

        path = "#{issue.self}/#{endpoint_name}?expand=transitions.fields"
        response = client.get(path)
        json = parse_json(response.body)
        json['transitions'].map do |transition|
          issue.transitions.build(transition)
        end
      end
    end

  end
end
