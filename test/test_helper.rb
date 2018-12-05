# frozen_string_literal: true

ENV['RAILS_ENV'] = 'test'

require 'simplecov'
SimpleCov.start

require 'benchmark'
require 'active_record'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: ':memory:'
)

ActiveRecord::Base.logger = Logger.new(STDOUT)

ActiveRecord::Schema.define do
  create_table :users, force: true do |t|
    t.string :first_name
    t.string :last_name
    t.string :title
    t.string :status, limit: 8
  end
end

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'attribute_extras'
require 'minitest/autorun'

class User < ActiveRecord::Base
  strip_attributes :first_name, :last_name
  nullify_attributes :title
  truncate_attributes :status
end
