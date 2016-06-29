$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
if ENV['TRAVIS']
  require 'coveralls'
  Coveralls.wear!
end

require 'lifx_dash'
require 'minitest/autorun'
