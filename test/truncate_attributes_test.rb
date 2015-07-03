require 'test_helper'

class TruncateAttributesTest < ActiveSupport::TestCase
  def test_truncated_name=
    person = Person.new
    person.truncated_name = Person.long_value
    assert_equal Person.short_value, person.truncated_name

    person.truncated_name = nil
    assert_equal nil, person.truncated_name

    person.truncated_name = 'test_value'
    assert_equal 'test_value', person.truncated_name
  end

  def test_truncated_whiny_name_validation
    person = Person.new
    person.truncated_whiny_name = Person.long_value

    assert_not person.save
    assert_equal ["is too long (maximum is #{COLUMN_LIMIT} characters)"],
      person.errors[:truncated_whiny_name]
  end

  def test_truncate_attributes
    person = Person.new
    person.set_long_attributes

    assert person.truncate_attributes
    assert_equal Person.short_value, person.truncated_name
    assert_equal Person.short_value, person.truncated_whiny_name
  end

  def test_truncate_attributes!
    person = Person.new
    person.set_long_attributes

    assert person.truncate_attributes!
    assert_equal Person.short_value, person.truncated_name
    assert_equal Person.short_value, person.truncated_whiny_name
  end

  def test_truncated_attributes_inheritance
    architect = Architect.new
    architect.set_long_attributes

    assert architect.truncate_attributes
    assert_equal Person.short_value, architect.truncated_name
    assert_equal Person.short_value, architect.truncated_whiny_name
    assert_equal Person.short_value, architect.other_truncated_name
  end

  def test_truncated_attributes
    assert_equal Person.truncated_attributes.map(&:attribute),
      [:truncated_name, :truncated_whiny_name]
    assert_equal Developer.truncated_attributes.map(&:attribute), []
    assert_equal Architect.truncated_attributes.map(&:attribute),
      [:other_truncated_name]
  end

  def test_inherited_truncated_attributes
    assert_equal Person.inherited_truncated_attributes.map(&:attribute),
      [:truncated_name, :truncated_whiny_name]
    assert_equal Developer.inherited_truncated_attributes.map(&:attribute),
      [:truncated_name, :truncated_whiny_name]
    assert_equal Architect.inherited_truncated_attributes.map(&:attribute),
      [:other_truncated_name, :truncated_name, :truncated_whiny_name]
  end
end
