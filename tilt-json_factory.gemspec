# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tilt/json_factory/version'

Gem::Specification.new do |spec|
  spec.name          = 'tilt-json_factory'
  spec.version       = Tilt::JSONFactory::Version::VERSION
  spec.author        = 'it@givve.com'

  spec.summary       = 'Marries Tilt and JSONFactory'
  spec.homepage      = 'https://github.com/givve/tilt-json_factory'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'json_factory', '~> 0.5.0'
  spec.add_runtime_dependency 'tilt', '~> 2.0.9'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'simplecov'
end
