require 'test_helper'

class TruncateAttributesTest < ActiveSupport::TestCase
  def test_truncate_attributes
    person = Person.new
    person.set_long_attributes

    assert person.truncate_attributes
    person_attributes.each do |attribute|
      assert_equal Person.short_value, person.send(attribute)
    end
  end

  def test_truncate_attributes!
    person = Person.new
    person.set_long_attributes

    assert person.truncate_attributes!
    person_attributes.each do |attribute|
      assert_equal Person.short_value, person.send(attribute)
    end
  end

  def test_truncated_attributes_inheritance
    architect = Architect.new
    architect.set_long_attributes

    assert architect.truncate_attributes
    architect_attributes.each do |attribute|
      assert_equal Architect.short_value, architect.send(attribute)
    end
  end

  def test_truncated_attributes
    assert_equal person_attributes, Person.truncated_attributes.map(&:attribute)
    assert_empty Developer.truncated_attributes.map(&:attribute)
    assert_equal [:architect_truncated], Architect.truncated_attributes.map(&:attribute)
  end

  def test_inherited_truncated_attributes
    assert_equal person_attributes, Person.inherited_truncated_attributes.map(&:attribute)
    assert_equal person_attributes, Developer.inherited_truncated_attributes.map(&:attribute)
    assert_equal architect_attributes, Architect.inherited_truncated_attributes.map(&:attribute)
  end

  private

    # a list of the attributes that are truncated on the architect class
    def architect_attributes
      @architect_attributes ||= ([:architect_truncated] + person_attributes)
    end

    # a list of the attributes that are truncated on the person class
    def person_attributes
      @person_attributes ||= [:person_truncated_one, :person_truncated_two, :person_truncated_three, :person_truncated_four]
    end
end
