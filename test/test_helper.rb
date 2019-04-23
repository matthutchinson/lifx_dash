# frozen_string_literal: true

if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start
  SimpleCov.at_exit do
    SimpleCov.result.format!
    `open ./coverage/index.html` if RUBY_PLATFORM =~ /darwin/
  end
end

require 'lifx_dash'
require 'minitest/autorun'
require 'webmock/minitest'

# set a quiet logger to /dev/null
LOGGER = Logger.new("/dev/null")
