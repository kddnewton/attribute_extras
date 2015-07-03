require 'test_helper'

class StripAttributesTest < ActiveSupport::TestCase
  def test_stripped_name=
    person = Person.new
    person.stripped_name = '  test value  '
    assert_equal 'test value', person.stripped_name

    person.stripped_name = nil
    assert_nil person.stripped_name

    person.stripped_name = 'test value'
    assert_equal 'test value', person.stripped_name
  end

  def test_strip_attributes
    person = Person.new
    person.set_padded_attributes

    assert person.strip_attributes
    assert_equal 'test value', person.stripped_name
  end

  def test_strip_attributes!
    person = Person.new
    person.set_padded_attributes

    assert person.strip_attributes!
    assert_equal 'test value', person.stripped_name
  end

  def test_stripped_attributes_inheritance
    architect = Architect.new
    architect.set_padded_attributes

    assert architect.strip_attributes
    assert_equal 'test value', architect.stripped_name
    assert_equal 'test value', architect.other_stripped_name
  end

  def test_stripped_attributes
    assert_equal Person.stripped_attributes.map(&:attribute),
      [:stripped_name]
    assert_equal Developer.stripped_attributes.map(&:attribute), []
    assert_equal Architect.stripped_attributes.map(&:attribute),
      [:other_stripped_name]
  end

  def test_inherited_stripped_attributes
    assert_equal Person.inherited_stripped_attributes.map(&:attribute),
      [:stripped_name]
    assert_equal Developer.inherited_stripped_attributes.map(&:attribute),
      [:stripped_name]
    assert_equal Architect.inherited_stripped_attributes.map(&:attribute),
      [:other_stripped_name, :stripped_name]
  end
end
