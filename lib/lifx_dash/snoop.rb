module LifxDash
  class Snoop

    attr_reader :iface

    def initialize(network_iface_id)
      @iface = network_iface_id
    end

    def run
      puts "Snooping for dash button packets on #{iface} ... press [CTRL-c] to stop\n\n"
      puts " * wait for the network to quiet down, before pressing the button"
      puts " * you might get more than 1 ARP packet when pressing, use the MAC address that occurs once\n\n"

      LifxDash::Capturer.new(iface).listen do |pkt, mac|
        LOGGER.info "possible Dash button press from MAC address: #{mac}"
      end
    end
  end
end
