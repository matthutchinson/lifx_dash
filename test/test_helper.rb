$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'lifx_dash'

# confgure test coverage reporting
if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start do
    add_filter '/test/'
    add_filter '/vendor/'
  end
  SimpleCov.at_exit do
    SimpleCov.result.format!
    `open ./coverage/index.html` if RUBY_PLATFORM =~ /darwin/
  end
elsif ENV['TRAVIS']
  require 'coveralls'
  Coveralls.wear!
end

require 'minitest/autorun'
