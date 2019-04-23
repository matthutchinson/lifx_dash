# frozen_string_literal: true

module LifxDash
  class Snoop

    attr_reader :iface

    def initialize(network_iface_id)
      @iface = network_iface_id
    end

    def run
      puts "Snooping for dash button packets on #{iface} ... press [CTRL-c] to stop\n\n"

      LifxDash::Capturer.new(iface).listen do |pkt, mac|
        LOGGER.info "possible Dash button press from MAC address: #{mac} -- pkt summary: #{pkt.peek}"
      end
    end
  end
end
