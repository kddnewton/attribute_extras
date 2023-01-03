# frozen_string_literal: true

require "test_helper"

class MacroTest < Minitest::Test
  def test_strip
    assert_includes AttributeExtras.constants, :StripAttributes

    user = User.create(first_name: "  Harry  ", last_name: "  Potter  ")
    assert_equal "Harry Potter", user.full_name

    user = User.create(first_name: "Harry", last_name: "Potter")
    assert_equal "Harry Potter", user.full_name

    user = User.new(first_name: "  Harry  ", last_name: "  Potter  ")
    user.strip_attributes
    assert_equal "Harry Potter", user.full_name
  end

  def test_nullify
    assert_includes AttributeExtras.constants, :NullifyAttributes

    user = User.create(title: "Student")
    assert_equal "Student", user.title

    user = User.create(title: "")
    assert_nil user.title

    user = User.new(title: "")
    user.nullify_attributes
    assert_nil user.title
  end

  def test_truncate
    assert_includes AttributeExtras.constants, :TruncateAttributes

    user = User.create(status: "Hunting horcruxes")
    assert_equal "Hunting ", user.status

    user = User.create(status: "Hunting")
    assert_equal "Hunting", user.status

    user = User.new(status: "Hunting horcruxes")
    user.truncate_attributes
    assert_equal "Hunting ", user.status
  end

  def test_define_macro
    AttributeExtras.define_extra :double_attributes do |*, value|
      value.is_a?(Numeric) ? value * 2 : value
    end

    User.double_attributes :age

    user = User.create(age: 10)
    assert_equal 20, user.age

    user = User.new(age: 10)
    user.double_attributes
    assert_equal 20, user.age
  end
end
