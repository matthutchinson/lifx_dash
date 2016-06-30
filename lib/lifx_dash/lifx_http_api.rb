require "net/https"
require "json"

module LifxDash
  class LifxHTTPApi

    BASE_URI = "api.lifx.com/v1"

    attr_reader :token, :logger

    ##
    # Initialize a new api client with a an API auth token and logger
    # If no logger is passed, the default LOGGER constant will be used e.g.
    #
    #   LifxDash::LifxHTTPApi.new("my-token-here", Logger.new(STDOUT))
    #
    def initialize(api_token, logger = LOGGER)
      @token = api_token
      @logger = logger
    end

    ##
    # Call the toggle-power endpoint on the LIFX HTTP API.
    # Pass a `selector` argument (defaults to 'all'). The API auth token is
    # passed via HTTP Basic AUTH.
    #
    # The method logs success, warning or errors to the logger. Success is
    # determined by a 2XX response code and a valid JSON response body like so:
    #
    #   {"results":[{"id":"d073d500ec8e","label":"Golden Boy","status":"ok"}]}
    #
    def toggle(selector = "all")
      uri = URI("https://#{BASE_URI}/lights/#{selector}/toggle")
      logger.info "Toggling lights! (via #{BASE_URI})"

      Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        req = Net::HTTP::Post.new(uri)
        req.add_field "Authorization", "Bearer #{token}"
        res = http.request(req)
        if res.code.to_s =~ /^2/ && success?(res.body)
          logger.info "Lights toggled successfully!"
          logger.info "API reply (#{res.code}): #{res.body}"
        else
          logger.warn "Warning: Possible issue with LIFX lights or HTTP API response"
          logger.warn "API reply (#{res.code}): #{res.body}"
        end
      end
    rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError, URI::InvalidURIError,
             Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
      logger.error "Error: POST request to #{BASE_URI} failed: #{e.message}"
      raise e
    end


    private

    def success?(response_body)
      results = parse_results(response_body)
      if results
        results.all? { |r| r["status"] == "ok" }
      end
    end

    def parse_results(response_body)
      if response_body && !response_body.strip.empty?
        JSON.parse(response_body)["results"]
      end
    rescue JSON::ParserError
      nil
    end
  end
end
