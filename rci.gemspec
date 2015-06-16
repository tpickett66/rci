# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rci/version'

Gem::Specification.new do |spec|
  spec.name          = 'rci'
  spec.version       = RCI::VERSION
  spec.authors       = ['Tyler Pickett']
  spec.email         = ['t.pickett66@gmail.com']

  spec.summary       = %q{Redis Client Instrumenter}
  spec.description   = %q{A little gem to wrap around calls to the official Ruby Redis clients and emmit ActiveSupport Notifications}
  spec.homepage      = 'https://github.com/tpickett66/rci'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.9'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.3'
end
