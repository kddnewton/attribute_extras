require 'test_helper'

class NullifyAttributesTest < ActiveSupport::TestCase
  def test_nullify_attributes
    person = Person.new
    person.set_blank_attributes

    assert person.nullify_attributes
    person_attributes.each do |attribute|
      assert_nil person.send(attribute)
    end
  end

  def test_nullify_attributes!
    person = Person.new
    person.set_blank_attributes

    assert person.nullify_attributes!
    person_attributes.each do |attribute|
      assert_nil person.send(attribute)
    end
  end

  def test_nullified_attributes_inheritance
    architect = Architect.new
    architect.set_blank_attributes

    assert architect.nullify_attributes
    architect_attributes.each do |attribute|
      assert_nil architect.send(attribute)
    end
  end

  def test_nullified_attributes
    assert_equal person_attributes, Person.nullified_attributes.map(&:attribute)
    assert_empty Developer.nullified_attributes.map(&:attribute)
    assert_equal [:architect_nullified], Architect.nullified_attributes.map(&:attribute)
  end

  def test_inherited_nullified_attributes
    assert_equal person_attributes, Person.inherited_nullified_attributes.map(&:attribute)
    assert_equal person_attributes, Developer.inherited_nullified_attributes.map(&:attribute)
    assert_equal architect_attributes, Architect.inherited_nullified_attributes.map(&:attribute)
  end

  private

    # a list of the attributes that are nullified on the architect class
    def architect_attributes
      @architect_attributes ||= ([:architect_nullified] + person_attributes)
    end

    # a list of the attributes that are nullified on the person class
    def person_attributes
      @person_attributes ||= [:person_nullified_one, :person_nullified_two, :person_nullified_three, :person_nullified_four]
    end
end
