# coding: utf-8
# frozen_string_literal: true
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'frilans_finans_api/version'

Gem::Specification.new do |spec|
  spec.name          = 'frilans_finans_api'
  spec.version       = FrilansFinansApi::VERSION
  spec.authors       = ['Jacob Burenstam']
  spec.email         = ['burenstam@gmail.com']

  spec.summary       = 'Interact with Frilans Finans API'
  spec.description   = 'Interact with Frilans Finans API (still under development)'
  spec.homepage      = 'https://github.com/justarrived/just-match-api.git'
  spec.license       = 'MIT'

  spec.files         = Dir['lib/   *.rb'] + Dir['lib/   *.json'] + Dir['bin/*']
  spec.bindir        = 'exe'
  spec.executables   = []
  spec.require_paths = ['lib']

  spec.add_dependency 'httparty', '~> 0.13' # Easy HTTP requests

  spec.add_development_dependency 'webmock', '~> 2.0'
  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
