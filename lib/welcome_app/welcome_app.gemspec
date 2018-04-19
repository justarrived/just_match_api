# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'welcome_app/version'

Gem::Specification.new do |spec|
  spec.name          = 'welcome_app'
  spec.version       = WelcomeApp::VERSION
  spec.authors       = ['Jacob Burenstam']
  spec.email         = ['burenstam@gmail.com']

  spec.summary       = 'Client for talking to Welcome! http://welcomemovement.se/'
  spec.description   = 'Client for talking to Welcome! http://welcomemovement.se/ not by any means complete yet..' # rubocop:disable Metrics/LineLength
  spec.homepage      = 'https://github.com/justarrived/just_match_api'
  spec.license       = 'MIT'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'httparty', '~> 0.13' # Easy HTTP requests

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'byebug', '~> 9.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
