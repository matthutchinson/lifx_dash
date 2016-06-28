require "net/https"
require "json"

module LifxDash
  class LifxHTTPApi

    BASE_URI = "api.lifx.com/v1"

    attr_reader :token

    def initialize(api_token)
      @token = api_token
    end

    def toggle(selector)
      uri = URI("https://#{BASE_URI}/lights/#{selector}/toggle")
      LOGGER.info "Toggling lights! (via #{BASE_URI})"

      Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        req = Net::HTTP::Post.new(uri)
        req.add_field "Authorization", "Bearer #{token}"
        res = http.request(req)
        if success?(res.body)
          LOGGER.info "Lights toggled successfully!"
          LOGGER.info "API reply (#{res.code}): #{res.body}"
        else
          LOGGER.warn "Warning: Possible issue with LIFX lights or HTTP API response"
          LOGGER.warn "API reply (#{res.code}): #{res.body}"
        end
      end
    rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError, URI::InvalidURIError,
             Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
      LOGGER.error "Error: POST request to #{BASE_URI} failed:"
      LOGGER.error e.message
      raise e
    end


    private

    def success?(response_body)
      parse_results(response_body).all? { |r| r["status"] == "ok" }
    end

    def parse_results(response_body)
      if response_body && !response_body.strip.empty?
        JSON.parse(response_body)["results"]
      else
        [{}]
      end
    end
  end
end
