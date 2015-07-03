require 'test_helper'

class BaseExtensionsTest < ActiveSupport::TestCase

  def test_nullify_attributes_failure
    assert_raises ArgumentError do
      klass = address_class(:nullify_attributes, :first_line, :second_line, :third_line)
      assert_not klass.respond_to?(:nullified_attributes)
    end
  end

  def test_nullify_attributes_success
    klass = address_class(:nullify_attributes, :first_line, :second_line)
    assert_equal klass.nullified_attributes.map(&:attribute), [:first_line, :second_line]
    assert_includes klass.instance_method(:first_line=).source_location.first, 'attribute_extras/base_extensions'
  end

  def test_strip_attributes_failure
    assert_raises ArgumentError do
      klass = address_class(:strip_attributes, :first_line, :second_line, :third_line)
      assert_not klass.respond_to?(:stripped_attributes)
    end
  end

  def test_strip_attributes_success
    klass = address_class(:strip_attributes, :first_line, :second_line)
    assert_equal klass.stripped_attributes.map(&:attribute), [:first_line, :second_line]
    assert_includes klass.instance_method(:first_line=).source_location.first, 'attribute_extras/base_extensions'
  end

  def test_truncate_attributes_failure
    assert_raises ArgumentError do
      klass = address_class(:truncate_attributes, :first_line, :second_line, :third_line)
      assert_not klass.respond_to?(:truncated_attributes)
    end
  end

  def test_truncate_attributes_success
    klass = address_class(:truncate_attributes, :first_line, :second_line)
    assert_equal klass.truncated_attributes.map(&:attribute), [:first_line, :second_line]
    assert_includes klass.instance_method(:first_line=).source_location.first, 'attribute_extras/base_extensions'
  end

  def test_truncate_attributes_success_whiny
    klass = address_class(:truncate_attributes, :first_line, :second_line, whiny: true)
    assert_equal klass.truncated_attributes.map(&:attribute), [:first_line, :second_line]

    validator = klass.validators_on(:first_line).first
    assert_kind_of ActiveModel::Validations::LengthValidator, validator
    assert_equal validator.options[:maximum], COLUMN_LIMIT
  end

  private

    # returns a newly created address class
    def address_class(macro, *arguments)
      Class.new(ActiveRecord::Base) do
        self.table_name = 'addresses'
        send(macro, *arguments)
      end
    end

end
