# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gem_velocity/version'

Gem::Specification.new do |spec|
  spec.name          = "gem_velocity"
  spec.version       = GemVelocity::VERSION
  spec.authors       = ["Shai Rosenfeld"]
  spec.email         = ["srosenfeld@engineyard.com"]
  spec.description   = %q{generate gem velocity images}
  spec.summary       = %q{generate gem velocity images}
  spec.homepage      = "https://github.com/shaiguitar/gem_velocities"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "gruff"
  spec.add_dependency "activesupport"
  spec.add_dependency "gems"
  spec.add_dependency "trollop", "1.16.2"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "webmock", "= 1.13" # vcr requirement?
  spec.add_development_dependency "timecop"
  spec.add_development_dependency "sourcify"
  spec.add_development_dependency "ParseTree"

end
