module LifxDash
  class Snoop

    attr_reader :iface

    def initialize(network_iface_id)
      @iface = network_iface_id
    end

    def run
      puts "Running snoop on #{iface}"
    end
  end
end
