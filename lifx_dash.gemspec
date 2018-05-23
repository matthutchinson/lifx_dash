# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lifx_dash/version'

Gem::Specification.new do |spec|
  spec.name          = "lifx_dash"
  spec.version       = LifxDash::VERSION
  spec.authors       = ["Matthew Hutchinson"]
  spec.email         = ["matt@hiddenloop.com"]

  spec.summary       = "Toggle LIFX lights with an Amazon Dash button"
  spec.homepage      = "http://github.com/matthutchinson/lifx_dash"
  spec.license       = "MIT"

  spec.description   = <<-EOF
  A command line tool to listen for Amazon Dash button presses and toggle LIFX
  lights ON and OFF (via the LIFX HTTP API). With options to configure: the Dash
  MAC address, network interface and LIFX bulb selector. Inspired by Ted
  Benson's hack (http://tinyurl.com/zba3da2). Root access is required for
  network packet sniffing.
  EOF

  spec.metadata = {
    "homepage_uri"    => "https://github.com/matthutchinson/lifx_dash",
    "changelog_uri"   => "https://github.com/matthutchinson/lifx_dash/blob/master/CHANGELOG.md",
    "source_code_uri" => "https://github.com/matthutchinson/lifx_dash",
    "bug_tracker_uri" => "https://github.com/matthutchinson/lifx_dash/issues",
  }

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the
  # 'allowed_push_host' to allow pushing to a single host or delete this section
  # to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|features)/}) }
  spec.test_files    = `git ls-files -- {test,features}/*`.split("\n")
  spec.bindir        = "bin"
  spec.executables   = "lifx_dash"
  spec.require_paths = ["lib"]

  # documentation
  spec.has_rdoc         = true
  spec.extra_rdoc_files = ['README.md', 'LICENSE.txt']
  spec.rdoc_options << '--title' << 'lifx_dash' << '--main' << 'README.md' << '-ri'

  # non-gem dependecies
  spec.required_ruby_version = ">= 2.1"
  spec.requirements << 'libpcap'
  spec.requirements << 'an Amazon Dash button'
  spec.requirements << 'one or more LIFX bulbs'
  spec.requirements << 'root access'

  # external gems
  spec.add_runtime_dependency "gli", "2.17.1"
  spec.add_runtime_dependency "packetfu", "1.1.13"

  # dev gems
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  # docs
  spec.add_development_dependency "ronn"
  spec.add_development_dependency "rdoc"
  # testing
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "aruba"
  spec.add_development_dependency "simplecov"
end
