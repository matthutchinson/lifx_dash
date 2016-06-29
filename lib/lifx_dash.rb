$LOAD_PATH.unshift File.expand_path('.')

require "logger"

require "lifx_dash/version"
require "lifx_dash/capturer"
require "lifx_dash/daemonizer"
require "lifx_dash/lifx_http_api"

# commands
require "lifx_dash/configuration"
require "lifx_dash/monitor"
require "lifx_dash/snoop"
