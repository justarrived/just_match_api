# coding: utf-8
# frozen_string_literal: true
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'json_api_helpers/version'

Gem::Specification.new do |spec|
  spec.name          = 'json_api_helpers'
  spec.version       = JsonApiHelpers::VERSION
  spec.authors       = ['Jacob Burenstam']
  spec.email         = ['burenstam@gmail.com']

  spec.summary       = 'A set of helpers for generating JSON API compliant responses.'
  spec.description   = 'A set of helpers for generating JSON API compliant responses with together with the active_model_serializers gem.' # rubocop:disable Metrics/LineLength
  spec.homepage      = 'https://github.com/justarrived/just_match_api/tree/master/lib/json_api_helpers'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) } # rubocop:disable Metrics/LineLength
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'active_model_serializers', '~> 0.10'
  spec.add_dependency 'activesupport', '>= 4.2'
  spec.add_dependency 'activemodel', '>= 4.2'

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
