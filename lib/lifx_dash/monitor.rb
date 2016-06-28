module LifxDash
  class Monitor

    attr_reader :token, :mac_address, :selector, :iface

    def initialize(token: , mac_address: , selector: "all", iface: "en0")
      @iface       = iface
      @token       = token
      @mac_address = mac_address
      @selector    = selector
    end

    def run
      puts "Starting lifx_dash monitor ..."
      puts " * listening on #{iface} for Dash button #{mac_address} presses to toggle #{selector} bulb(s)"

      LifxDash::Capturer.new(iface).listen do |pkt, mac|
        lifx_api.toggle(selector) if mac == mac_address
      end
    end

    private

    def lifx_api
      @lifx_api ||= LifxDash::LifxHTTPApi.new(token)
    end
  end
end
