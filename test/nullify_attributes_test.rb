require 'test_helper'

class NullifyAttributesTest < ActiveSupport::TestCase
  def test_nullified_name=
    person = Person.new
    person.nullified_name = '   '
    assert_nil person.nullified_name

    person.nullified_name = nil
    assert_nil person.nullified_name

    person.nullified_name = 'test_value'
    assert_equal 'test_value', person.nullified_name
  end

  def test_nullify_attributes
    person = Person.new
    person.set_blank_attributes

    assert person.nullify_attributes
    assert_nil person.nullified_name
  end

  def test_nullify_attributes!
    person = Person.new
    person.set_blank_attributes

    assert person.nullify_attributes!
    assert_nil person.nullified_name
  end

  def test_nullified_attributes_inheritance
    architect = Architect.new
    architect.set_blank_attributes

    assert architect.nullify_attributes
    assert_nil architect.nullified_name
    assert_nil architect.other_nullified_name
  end

  def test_nullified_attributes
    assert_equal Person.nullified_attributes.map(&:attribute),
      [:nullified_name]
    assert_equal Developer.nullified_attributes.map(&:attribute), []
    assert_equal Architect.nullified_attributes.map(&:attribute),
      [:other_nullified_name]
  end

  def test_inherited_nullified_attributes
    assert_equal Person.inherited_nullified_attributes.map(&:attribute),
      [:nullified_name]
    assert_equal Developer.inherited_nullified_attributes.map(&:attribute),
      [:nullified_name]
    assert_equal Architect.inherited_nullified_attributes.map(&:attribute),
      [:other_nullified_name, :nullified_name]
  end
end
