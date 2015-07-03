$:.push File.expand_path('../lib', __FILE__)

require 'attribute_extras/version'

Gem::Specification.new do |s|
  s.name        = 'attribute_extras'
  s.version     = AttributeExtras::VERSION
  s.authors     = ['Kevin Deisz']
  s.email       = ['kevin.deisz@gmail.com']
  s.homepage    = 'https://github.com/kddeisz/attribute_extras'
  s.summary     = 'Extra macros for auto attribute manipulation.'
  s.description = <<-MSG.squish
    Overrides writers methods on ActiveRecord classes to allow for
    different behavior such as nullifying, stripping, and truncating.
  MSG
  s.license     = 'MIT'

  s.files = Dir['lib/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['test/**/*']

  s.add_dependency 'rails', '> 3'

  s.add_development_dependency 'sqlite3'
end
