require 'json'
require 'forwardable'

module JiraRestApi

  # This class is the main access point for all JiraRestApi::Resource instances.
  #
  # The client must be initialized with an options hash containing 
  # configuration options.  The available options are:
  #
  #   :site               => 'http://localhost:2990',
  #   :context_path       => '/jira',
  #   :signature_method   => 'RSA-SHA1',
  #   :request_token_path => "/plugins/servlet/oauth/request-token",
  #   :authorize_path     => "/plugins/servlet/oauth/authorize",
  #   :access_token_path  => "/plugins/servlet/oauth/access-token",
  #   :private_key_file   => "rsakey.pem",
  #   :rest_base_path     => "/rest/api/2",
  #   :consumer_key       => nil,
  #   :consumer_secret    => nil,
  #   :ssl_verify_mode    => OpenSSL::SSL::VERIFY_PEER,
  #   :use_ssl            => true,
  #   :username           => nil,
  #   :password           => nil,
  #   :auth_type          => :oauth
  #   :proxy_address      => nil
  #   :proxy_port         => nil
  #
  # See the JiraRestApi::Base class methods for all of the available methods on these accessor
  # objects.
  
  class Client

    extend Forwardable

    # The OAuth::Consumer instance returned by the OauthClient
    #
    # The authenticated client instance returned by the respective client type
    # (Oauth, Basic)
    attr_accessor :consumer, :request_client

    # The configuration options for this client instance
    attr_reader :options

    def_delegators :@request_client, :init_access_token, :set_access_token, :set_request_token, :request_token, :access_token

    DEFAULT_OPTIONS = {
      :site               => 'http://localhost:2990',
      :context_path       => '/jira',
      :rest_base_path     => "/rest/api/2",
      :ssl_verify_mode    => OpenSSL::SSL::VERIFY_PEER,
      :use_ssl            => true,
      :auth_type          => :oauth,
      :debug              => false,
      :headers            => {}
    }

    DEFAULT_HEADERS = {
      'Accept' => 'application/json'
    }

    def initialize(options={})
      @options = DEFAULT_OPTIONS.merge(options)
      @options[:rest_base_path] = @options[:context_path] + @options[:rest_base_path]

      case options[:auth_type]
      when :oauth
        @request_client = OauthClient.new(@options)
        @consumer = @request_client.consumer
      when :basic
        @request_client = HttpClient.new(@options)
      end

      @options.freeze
    end

    def Project # :nodoc:
      JiraRestApi::Resource::ProjectFactory.new(self)
    end

    def Issue # :nodoc:
      JiraRestApi::Resource::IssueFactory.new(self)
    end

    def Filter # :nodoc:
      JiraRestApi::Resource::FilterFactory.new(self)
    end

    def Component # :nodoc:
      JiraRestApi::Resource::ComponentFactory.new(self)
    end

    def User # :nodoc:
      JiraRestApi::Resource::UserFactory.new(self)
    end

    def Issuetype # :nodoc:
      JiraRestApi::Resource::IssuetypeFactory.new(self)
    end

    def Priority # :nodoc:
      JiraRestApi::Resource::PriorityFactory.new(self)
    end

    def Status # :nodoc:
      JiraRestApi::Resource::StatusFactory.new(self)
    end

    def Comment # :nodoc:
      JiraRestApi::Resource::CommentFactory.new(self)
    end

    def Attachment # :nodoc:
      JiraRestApi::Resource::AttachmentFactory.new(self)
    end

    def Worklog # :nodoc:
      JiraRestApi::Resource::WorklogFactory.new(self)
    end

    def Version # :nodoc:
      JiraRestApi::Resource::VersionFactory.new(self)
    end

    def Transition # :nodoc:
      JiraRestApi::Resource::TransitionFactory.new(self)
    end

    # HTTP methods without a body
    def delete(path, headers = {})
      request(:delete, path, nil, merge_default_headers(headers))
    end

    def get(path, headers = {})
      request(:get, path, nil, merge_default_headers(headers))
    end

    def head(path, headers = {})
      request(:head, path, nil, merge_default_headers(headers))
    end

    # HTTP methods with a body
    def post(path, body = '', headers = {})
      headers = {'Content-Type' => 'application/json'}.merge(headers)
      request(:post, path, body, merge_default_headers(headers))
    end

    def put(path, body = '', headers = {})
      headers = {'Content-Type' => 'application/json'}.merge(headers)
      request(:put, path, body, merge_default_headers(headers))
    end

    # Sends the specified HTTP request to the REST API through the
    # appropriate method (oauth, basic).
    def request(http_method, path, body = '', headers={})
      @request_client.request(http_method, path, body, headers)
    end

    protected

      def merge_default_headers(headers)
        DEFAULT_HEADERS.merge(headers)
      end

  end
end
