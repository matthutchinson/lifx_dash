module LifxDash
  class Daemonizer

    LOG_FILE = "/tmp/lifx_dash.log"

    def self.start(log_file = LOG_FILE)
      # start daemon fork (skip IO redirect to /dev/null)
      Process.daemon(false, true)
      # show pid and log file info on stdout
      puts "[#{Process.pid}] Starting lifx_dash ... (daemon logging to #{log_file})"
      redirect_io(log_file)
    end

    # Free the STDIN/STDOUT/STDERR file descriptors and point them somewhere
    # sensible
    def self.redirect_io(log_file)
      begin; STDIN.reopen '/dev/null'; rescue ::Exception; end

      begin
        # ensure log file exists with good permissions
        FileUtils.mkdir_p(File.dirname(log_file), :mode => 0755)
        FileUtils.touch log_file
        File.chmod(0644, log_file)

        # reopen STOUT stream to file
        STDOUT.reopen log_file, 'a'
        STDOUT.sync = true
      rescue ::Exception
        begin; STDOUT.reopen '/dev/null'; rescue ::Exception; end
      end

      # reopen STERR stream to STDOUT (file stream)
      begin; STDERR.reopen STDOUT; rescue ::Exception; end
      STDERR.sync = true
    end
  end
end
