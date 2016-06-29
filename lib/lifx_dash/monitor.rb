module LifxDash
  class Monitor

    attr_reader :token, :mac, :selector, :iface

    def initialize(token: nil, mac: nil, selector: "all", iface: "en0")
      @iface    = iface
      @token    = token
      @mac      = mac
      @selector = selector
    end

    def run
      puts "Starting lifx_dash monitor ..."
      puts " * listening on #{iface} for Dash button #{mac} presses to toggle #{selector} bulb(s)"

      LifxDash::Capturer.new(iface).listen do |pkt, source_mac_addr|
        if source_mac_addr == mac
          LOGGER.info "Detected Dash button press from MAC address: #{mac} -- pkt summary: #{pkt.peek}"
          lifx_api.toggle(selector)
        end
      end
    end

    private

    def lifx_api
      @lifx_api ||= LifxDash::LifxHTTPApi.new(token)
    end
  end
end
