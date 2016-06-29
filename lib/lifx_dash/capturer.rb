require "packetfu"

module LifxDash
  class Capturer

    attr_reader :iface

    def initialize(network_iface_id)
      @iface = network_iface_id
    end

    def listen(&block)
      # examine packets on the stream
      capturer.stream.each do |packet|
        pkt = PacketFu::ARPPacket.parse(packet)
        # parse packet header
        mac = PacketFu::EthHeader.str2mac(pkt.eth_src)
        # valid ARP pkt when opcode is 1
        if pkt.arp_opcode == 1
          block.call(pkt, mac) if block
        end
      end
    end


    private

    def capturer
      # filter and capture ARP packets on network interface
      @capturer ||= PacketFu::Capture.new(
        iface: @iface,
        start: true,
        filter: "arp"
      )
    end
  end
end
