if ENV['COVERAGE']
  require 'simplecov'
end

require 'lifx_dash'
require 'minitest/autorun'
require 'webmock/minitest'

# set a quiet logger to /dev/null
LOGGER = Logger.new("/dev/null")
