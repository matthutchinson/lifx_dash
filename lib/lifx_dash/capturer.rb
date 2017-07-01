require "packetfu"

module LifxDash
  class Capturer

    # Berkeley Packet filter for Amazon Dash buttons
    #
    #  - older dash buttons issue an ARP packet from 0.0.0.0
    #  - newer buttons broadcast a DHCP request from 0.0.0.0
    #  - use the following bfp in WireShark to snoop for raw packets
    #    - (arp or (udp.srcport == 68 and udp.dstport == 67)) and ip.src == 0.0.0.0
    #  - for more details see https://github.com/ide/dash-button/issues/36
    #
    PACKET_FILTER = "(arp or (udp and src port 68 and dst port 67)) and src host 0.0.0.0"

    attr_reader :iface

    def initialize(network_iface_id)
      @iface = network_iface_id
    end

    def listen(&block)
      # examine packets on the stream
      capturer.stream.each do |packet|
        pkt = PacketFu::IPPacket.parse(packet)
        # only consider the first packet sent
        if pkt && pkt.ip_id == 1
          mac = PacketFu::EthHeader.str2mac(pkt.eth_src)
          block.call(pkt, mac) if block
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
