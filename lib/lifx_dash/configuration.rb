require "yaml"

module LifxDash
  class Configuration

    CONFIG_FILE_NAME = ".lifx_dash.rc.yml"
    OPTION_PROMPTS   = {
      "iface"       => "Network interface identifier e.g. en0 (choose from ifconfig -l)",
      "token"       => "LIFX API token (get a free personal token at cloud.lifx.com)",
      "mac-address" => "Dash button MAC address (use lifx_dash snoop to find it)",
      "selector"    => "LIFX bulb selector e.g. all or a LIFX bulb ID",
      "log-file"    => "Log file location (when running as a daemon)"
    }

    def [](key)
      config_options[key]
    end

    def show
      if File.exist?(config_file)
        puts "Configuration file at #{config_file} ...\n\n"
        puts File.read(config_file)
        puts "\nChange these options with `lifx_dash config`"
      else
        puts "No configuration file exists at #{config_file}"
      end
    end

    def configure
      puts "Configuring lifx_dash ...\n\n"
      user_options = ask_for_options

      if user_options.values.all?(&:nil?)
        puts "\nNo options set, configuration is unchanged"
      else
        File.open(config_file, "w") do |file|
          YAML::dump(user_options, file)
        end
        puts "\nConfiguration saved to #{config_file}"
      end
    end

    private

    def config_file
      @config_file ||= begin
        home_dir = ENV["HOME"]

        # when running as sudo on linux, use the sudo users' home dir
        if platform == :linux &&
             ENV["SUDO_USER"] &&
             File.exist?("/home/#{ENV["SUDO_USER"]}")
          home_dir = "/home/#{ENV["SUDO_USER"]}"
        end

        File.join(home_dir, CONFIG_FILE_NAME)
      end
    end

    def config_options
      @config_options ||= begin
        if File.exist?(config_file)
          YAML.load_file(config_file)
        else
          {}
        end
      end
    end

    def ask_for_options
      OPTION_PROMPTS.keys.reduce({}) do |acc, key|
        print " * #{OPTION_PROMPTS[key]}: "
        acc.merge(key => parse_user_input(STDIN.gets.strip))
      end
    end

    def platform
      case RbConfig::CONFIG['host_os']
      when /linux/
        :linux
      when /darwin/
        :mac
      when /(win|w)32/
        :windows
      else
        :unknown
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
