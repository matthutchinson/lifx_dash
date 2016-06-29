require "net/https"
require "json"

module LifxDash
  class LifxHTTPApi

    BASE_URI = "api.lifx.com/v1"

    attr_reader :token, :logger

    def initialize(api_token, logger = LOGGER)
      @token = api_token
      @logger = logger
    end

    def toggle(selector)
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
