# frozen_string_literal: true

module LifxDash
  class Daemonizer

    LOG_FILE = "/tmp/lifx_dash.log"

    def self.start(log_file = LOG_FILE)
      # fork process (skip IO redirect to /dev/null)
      Process.daemon(false, true)
      # show pid and log file info on stdout right away
      puts "[#{Process.pid}] Starting lifx_dash ... (daemon logging to #{log_file})"
      redirect_io(log_file)
    end

    # Free the STDIN/STDOUT/STDERR file descriptors and point them somewhere
    # sensible - inspired by daemons gem
    def self.redirect_io(log_file)
      STDIN.reopen '/dev/null'

      begin
        # ensure log file exists with good permissions
        FileUtils.mkdir_p(File.dirname(log_file), :mode => 0755)
        FileUtils.touch log_file
        File.chmod(0644, log_file)

        # reopen STOUT stream to file
        STDOUT.reopen log_file, 'a'
        STDOUT.sync = true
      rescue ::StandardError
        STDOUT.reopen '/dev/null'
      end

      # reopen STERR stream to STDOUT (file stream)
      STDERR.reopen STDOUT
      STDERR.sync = true
    rescue => e
      raise "#{self} - error: could not redirect IO - #{e.message}"
    end
  end
end
