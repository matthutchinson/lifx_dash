require "packetfu"

module LifxDash
  class Capturer

    attr_reader :iface

    def initialize(network_iface_id)
      @iface = network_iface_id
    end

    def listen(&block)
      # listen to packet stream
      capturer.stream.each do |packet|
        # parse packets
        pkt = PacketFu::ARPPacket.parse(packet)
        mac = PacketFu::EthHeader.str2mac(pkt.eth_src)
        # execute block when ARP opcode is 1
        if pkt.arp_opcode == 1
          block.call(pkt, mac) if block
        end
      end
    end


    private

    def capturer
      # filter and capture ARP packets
      @capturer ||= PacketFu::Capture.new(
        iface: @iface,
        start: true,
        filter: "arp"
      )
    end
  end
end
