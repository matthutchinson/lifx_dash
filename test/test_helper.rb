if ENV['COVERAGE']
  if ENV['TRAVIS']
    require 'coveralls'
    Coveralls.wear!
  else
    require 'simplecov'
  end
end

require 'lifx_dash'
require 'minitest/autorun'
require 'webmock/minitest'

# set a quiet logger to /dev/null
LOGGER = Logger.new("/dev/null")
