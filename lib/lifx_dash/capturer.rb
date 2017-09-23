require "packetfu"

module LifxDash
  class Capturer

    # Berkeley Packet filter for Amazon Dash buttons
    #
    #  - most dash buttons broadcast a DHCP request from 0.0.0.0
    #  - for more details see https://github.com/ide/dash-button/issues/36
    #
    PACKET_FILTER = "udp and src port 68 and dst port 67 and udp[247:4] == 0x63350103 and src host 0.0.0.0"

    attr_reader :iface

    def initialize(network_iface_id)
      @iface = network_iface_id
    end

    def listen(&block)
      # examine packets on the stream
      capturer.stream.each do |packet|
        if PacketFu::IPPacket.can_parse?(packet)
          pkt = PacketFu::IPPacket.parse(packet)
          # only consider the first (early ip ids) even packet sent
          # since dhcp often sends 2 packets in a quick burst
          if pkt && pkt.ip_id < 5 && (pkt.ip_id % 2) == 0
            puts pkt.inspect
            mac = PacketFu::EthHeader.str2mac(pkt.eth_src)
            block.call(pkt, mac) if block
          end
        end
      end
    end

    private
    def capturer
      # capture (and filter) packets on network interface
      @capturer ||= PacketFu::Capture.new(
        iface: @iface,
        start: true,
        filter: PACKET_FILTER
      )
    end
  end
end
