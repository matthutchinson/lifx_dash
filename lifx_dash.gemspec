# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lifx_dash/version'

Gem::Specification.new do |spec|
  spec.name          = "lifx_dash"
  spec.version       = LifxDash::VERSION
  spec.authors       = ["Matthew Hutchinson"]
  spec.email         = ["matt@hiddenloop.com"]

  spec.summary       = %q{Control LIFX lights with an Amazon Dash Button}
  spec.homepage      = "http://github.com/matthutchinson/lifx_dash"
  spec.license       = "MIT"

  spec.description   = %q{A long running Ruby daemon process that will listen
  for an Amazon dash button press and toggle LIFX lights ON or OFF via the LIFX
  HTTP API. With options to configure, dash MAC address, network iface to listen
  on and LIFX selector name. Inspired by Ted Benson's hack
  (http://tinyurl.com/zba3da2)}

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the
  # 'allowed_push_host' to allow pushing to a single host or delete this section
  # to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "coveralls"
end
