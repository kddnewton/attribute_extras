$:.push File.expand_path('../lib', __FILE__)

require 'attribute_extras/version'

Gem::Specification.new do |s|
  s.name        = 'attribute_extras'
  s.version     = AttributeExtras::VERSION
  s.authors     = ['Kevin Deisz']
  s.email       = ['info@trialnetworks.com']
  s.homepage    = 'https://github.com/drugdev/attribute_extras'
  s.summary     = 'Extra macros for auto attribute manipulation.'
  s.description = 'Builds macros to automatically manipulate your models\' attributes.'
  s.license     = 'MIT'

  s.files = Dir['lib/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['test/**/*']

  s.add_dependency 'rails', '> 3'

  s.add_development_dependency 'sqlite3'
end
