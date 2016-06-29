require "yaml"

module LifxDash
  class Configuration

    CONFIG_FILE    = File.join(ENV["HOME"], ".lifx_dash.rc.yml")
    OPTION_PROMPTS = {
      "iface"       => "Network interface identifier e.g. en0 (choose from ifconfig -l)",
      "token"       => "LIFX API token (get a free personal token at cloud.lifx.com)",
      "mac-address" => "Dash button MAC address (use lifx_dash snoop to find it)",
      "selector"    => "LIFX bulb selector e.g. all or a LIFX bulb ID",
      "log-file"    => "Log file location (when running as a daemon)"
    }

    def self.load
      if File.exist?(CONFIG_FILE)
        YAML.load_file(CONFIG_FILE)
      else
        {}
      end
    end

    def run(show_config: false)
      # decide to show config or start configuring
      show_config ? show : configure
    end

    def show
      if File.exist?(CONFIG_FILE)
        puts "Configuration file at #{CONFIG_FILE} ...\n\n"
        puts File.read(CONFIG_FILE)
        puts "\nChange these options with `lifx_dash config`"
      else
        puts "No configuration file exists at #{CONFIG_FILE}"
      end
    end

    def configure
      puts "Configuring lifx_dash ...\n\n"
      user_options = ask_for_options

      if user_options.values.all?(&:nil?)
        puts "\nNo options set, configuration is unchanged"
      else
        File.open(CONFIG_FILE, "w") do |file|
          YAML::dump(user_options, file)
        end
        puts "\nConfiguration saved to #{CONFIG_FILE}"
      end
    end

    def ask_for_options
      OPTION_PROMPTS.keys.reduce({}) do |acc, key|
        print " * #{OPTION_PROMPTS[key]}: "
        acc.merge(key => parse_user_input(STDIN.gets.strip))
      end
    end

    def parse_user_input(str)
      # handle empty strings
      if str.empty?
        nil
      else
        str
      end
    end
  end
end
