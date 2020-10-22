# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'attribute_extras/version'

Gem::Specification.new do |spec|
  spec.name          = 'attribute_extras'
  spec.version       = AttributeExtras::VERSION
  spec.authors       = ['Kevin Deisz']
  spec.email         = ['kevin.deisz@gmail.com']

  spec.summary       = 'Extra macros for auto attribute manipulation.'
  spec.description   = <<~DOC
    Builds macros to automatically manipulate your models' attributes.
  DOC
  spec.homepage      = 'https://github.com/kddeisz/attribute_extras'
  spec.license       = 'MIT'

  spec.files         =
    Dir.chdir(__dir__) do
      `git ls-files -z`.split("\x0").reject do |f|
        f.match(%r{^(test|spec|features)/})
      end
    end

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activerecord', '> 3'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rubocop', '~> 1.0'
  spec.add_development_dependency 'simplecov', '~> 0.17'
  spec.add_development_dependency 'sqlite3', '~> 1.4'
end
