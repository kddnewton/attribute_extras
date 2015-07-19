require 'test_helper'

class StripAttributesTest < ActiveSupport::TestCase
  def test_strip_attributes
    person = Person.new
    person.set_padded_attributes

    assert person.strip_attributes
    person_attributes.each do |attribute|
      assert_equal Person.stripped_value, person.send(attribute)
    end
  end

  def test_strip_attributes!
    person = Person.new
    person.set_padded_attributes

    assert person.strip_attributes!
    person_attributes.each do |attribute|
      assert_equal Person.stripped_value, person.send(attribute)
    end
  end

  def test_stripped_attributes_inheritance
    architect = Architect.new
    architect.set_padded_attributes

    assert architect.strip_attributes
    architect_attributes.each do |attribute|
      assert_equal Architect.stripped_value, architect.send(attribute)
    end
  end

  def test_stripped_attributes
    assert_equal person_attributes, Person.stripped_attributes.map(&:attribute)
    assert_empty Developer.stripped_attributes.map(&:attribute)
    assert_equal [:architect_stripped], Architect.stripped_attributes.map(&:attribute)
  end

  def test_inherited_stripped_attributes
    assert_equal person_attributes, Person.inherited_stripped_attributes.map(&:attribute)
    assert_equal person_attributes, Developer.inherited_stripped_attributes.map(&:attribute)
    assert_equal architect_attributes, Architect.inherited_stripped_attributes.map(&:attribute)
  end

  private

    # a list of the attributes that are stripped on the architect class
    def architect_attributes
      @architect_attributes ||= ([:architect_stripped] + person_attributes)
    end

    # a list of the attributes that are stripped on the person class
    def person_attributes
      @person_attributes ||= [:person_stripped_one, :person_stripped_two, :person_stripped_three, :person_stripped_four]
    end
end
