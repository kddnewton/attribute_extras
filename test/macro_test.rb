# frozen_string_literal: true

require 'test_helper'

class MacroTest < Minitest::Test
  def test_strip
    user = User.create(first_name: '  Harry  ', last_name: '  Potter  ')
    assert_equal 'Harry', user.first_name
    assert_equal 'Potter', user.last_name

    user = User.create(first_name: 'Harry', last_name: 'Potter')
    assert_equal 'Harry', user.first_name
    assert_equal 'Potter', user.last_name
  end

  def test_nullify
    user = User.create(title: 'Student')
    assert_equal 'Student', user.title

    user = User.create(title: '')
    assert_nil user.title
  end

  def test_truncate
    user = User.create(status: 'Hunting horcruxes')
    assert_equal 'Hunting ', user.status

    user = User.create(status: 'Hunting')
    assert_equal 'Hunting', user.status
  end
end
