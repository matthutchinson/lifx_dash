module LifxDash
  class Monitor

    attr_reader :token, :mac_address, :selector, :iface

    def initialize(token: , mac_address: , selector: 'all', iface: 'en0')
      @iface       = iface
      @token       = token
      @mac_address = mac_address
      @selector    = selector
    end

    def run
      help_now!("a valid Dash button MAC address option (-m) is required: use `lifx_dash snoop #{iface}` to find it") unless mac_address
      help_now!('a valid LIFX API Token option (-t) is required: get one from https://cloud.lifx.com/settings') unless token

      puts "Running monitor"

      puts "token: #{token}"
      puts "mac_address: #{mac_address}"
      puts "selector: #{selector}"
      puts "iface: #{iface}"

      puts "monitor command ran"
    end
  end
end
