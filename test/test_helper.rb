$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

begin
  require 'bundler/inline'
rescue LoadError => e
  $stderr.puts 'Bundler version 1.10 or later is required. Please update your Bundler'
  raise e
end

gemfile(true) do
  source 'https://rubygems.org'
  gem 'activerecord'
  gem 'sqlite3'
end

require 'active_record'
require 'minitest/autorun'
require 'logger'
require 'attribute_extras'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')
ActiveRecord::Base.logger = Logger.new(STDOUT)
ActiveSupport.test_order = :sorted

require 'test_classes'
