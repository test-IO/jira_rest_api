require 'oauth'
require 'json'
require 'net/https'

module JiraRestApi
  class RequestClient

    # Returns the response if the request was successful (HTTP::2xx) and
    # raises a JiraRestApi::HTTPError if it was not successful, with the response
    # attached.

    def request(*args)
      response = make_request(*args)
      case response.class
      when Net::HTTPSuccess
        response
      when Net::HTTPFound
        # Todo: Implement redirect following
        raise HTTPError.new(response)
      else
        raise HTTPError.new(response)
      end
      response
    end
  end
end
