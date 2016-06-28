module LifxDash
  class Daemonizer

    LOG_FILE = "/tmp/lifx_dash.log"

    def self.start
      # start daemon fork (skip io redirect to /dev/null)
      Process.daemon(false, true)
      # show pid and log file info on stdout
      puts "[#{Process.pid}] Starting lifx_dash ... (daemon logging to #{LOG_FILE})"
      redirect_io(LOG_FILE)
    end

    # Free STDIN/STDOUT/STDERR file descriptors and
    # point them somewhere sensible
    def self.redirect_io(log_file)
      begin; STDIN.reopen '/dev/null'; rescue ::Exception; end

      begin
        # ensure file exists with permissions
        FileUtils.mkdir_p(File.dirname(log_file), :mode => 0755)
        FileUtils.touch log_file
        File.chmod(0644, log_file)
        # reopen stream
        STDOUT.reopen log_file, 'a'
        STDOUT.sync = true
      rescue ::Exception
        begin; STDOUT.reopen '/dev/null'; rescue ::Exception; end
      end

      begin; STDERR.reopen STDOUT; rescue ::Exception; end
      STDERR.sync = true
    end
  end
end
