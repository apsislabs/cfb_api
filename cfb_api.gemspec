# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cfb_api/version'

Gem::Specification.new do |spec|
  spec.name          = 'cfb_api'
  spec.version       = CFB::VERSION
  spec.authors       = ['Wyatt Kirby']
  spec.email         = ['wyatt@apsis.io']

  spec.summary       = 'A Ruby client for collegefootballdata.com.'
  # spec.homepage      = "TODO: Put your gem's website or public repo URL here."
  spec.license       = 'MIT'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'faraday'
  spec.add_runtime_dependency 'virtus'
  spec.add_runtime_dependency 'strings-case'

  spec.add_development_dependency 'bundler', '~> 1.17'
  spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'rubocop'
end
