$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'active_record'
require 'minitest/autorun'
require 'attribute_extras'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')
ActiveSupport.test_order = :sorted

require 'test_classes'
