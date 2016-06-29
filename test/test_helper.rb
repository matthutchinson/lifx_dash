$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

if ENV['COVERAGE']
  if ENV['TRAVIS']
    require "codeclimate-test-reporter"
    CodeClimate::TestReporter.start
    require 'coveralls'
    Coveralls.wear!
  else
    require 'simplecov'
  end
end

require 'lifx_dash'
require 'minitest/autorun'
