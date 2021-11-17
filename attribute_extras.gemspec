# frozen_string_literal: true

require_relative 'lib/attribute_extras/version'

version = AttributeExtras::VERSION
repository = 'https://github.com/kddnewton/attribute_extras'

Gem::Specification.new do |spec|
  spec.name          = 'attribute_extras'
  spec.version       = version
  spec.authors       = ['Kevin Newton']
  spec.email         = ['kddnewton@gmail.com']

  spec.summary       = 'Extra macros for auto attribute manipulation.'
  spec.description   = <<~DOC
    Builds macros to automatically manipulate your models' attributes.
  DOC
  spec.homepage      = repository
  spec.license       = 'MIT'

  spec.metadata      = {
    'bug_tracker_uri' => "#{repository}/issues",
    'changelog_uri' => "#{repository}/blob/v#{version}/CHANGELOG.md",
    'source_code_uri' => repository,
    'rubygems_mfa_required' => 'true'
  }

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
  spec.add_development_dependency 'rubocop', '~> 1.12'
  spec.add_development_dependency 'simplecov', '~> 0.17'
  spec.add_development_dependency 'sqlite3', '~> 1.4'
end
