require 'json'
require 'net/https'
require 'net/http/post/multipart'

module JiraRestApi
  class HttpClient < RequestClient

    DEFAULT_OPTIONS = {
      :username           => '',
      :password           => '',
      :debug              => false
    }

    attr_reader :options

    def initialize(options)
      @options = DEFAULT_OPTIONS.merge(options)
    end

    def make_request(http_method, path, body='', headers={})
      if http_method == :upload
        # Add Atlassian XSRF check bypass header
        headers.merge! 'X-Atlassian-Token' => 'nocheck'

        # XXX: should we raise an exception if file param is blank?
        # XXX: should we detect mime type if none provided?
        # Set filename if none set by caller
        body['filename'] ||= File.basename body['content']

        request = Net::HTTP::Post::Multipart.new(path, { 'file' => UploadIO.new(body['content'], body['type'], body['filename']) }, headers)
      else
        headers = headers.merge(@options[:headers]) if @options[:headers]
        request = Net::HTTP.const_get(http_method.to_s.capitalize).new(path, headers)
        request.body = body unless body.nil?
      end
      request.basic_auth(@options[:username], @options[:password])
      response = basic_auth_http_conn.request(request)
      response
    end

    def basic_auth_http_conn
      http_conn(uri)
    end

    def http_conn(uri)
      if @options[:proxy_address] 
          http_class = Net::HTTP::Proxy(@options[:proxy_address], @options[:proxy_port] ? @options[:proxy_port] : 80)
      else
          http_class = Net::HTTP
      end
      http_conn             = http_class.new(uri.host, uri.port)
      http_conn.use_ssl     = @options[:use_ssl]
      http_conn.verify_mode = @options[:ssl_verify_mode]
      if options[:debug]
        http_conn.set_debug_output($stdout)
      end
      http_conn
    end

    def uri
      uri = URI.parse(@options[:site])
    end
  end
end
