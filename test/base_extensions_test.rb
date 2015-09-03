require 'test_helper'

class BaseExtensionsTest < ActiveSupport::TestCase

  def test_nullify_attributes_warns
    assert_output_matches 'Invalid attributes' do
      address_class(:nullify_attributes, :first_line, :second_line, :third_line)
    end
  end

  def test_nullify_attributes_success
    klass = address_class(:nullify_attributes, :first_line, :second_line)
    assert_equal klass.nullified_attributes.map(&:attribute), [:first_line, :second_line]
  end

  def test_strip_attributes_warns
    assert_output_matches 'Invalid attributes' do
      address_class(:strip_attributes, :first_line, :second_line, :third_line)
    end
  end

  def test_strip_attributes_success
    klass = address_class(:strip_attributes, :first_line, :second_line)
    assert_equal klass.stripped_attributes.map(&:attribute), [:first_line, :second_line]
  end

  def test_truncate_attributes_success
    klass = address_class(:truncate_attributes, :first_line, :second_line)
    assert_equal klass.truncated_attributes.map(&:attribute), [:first_line, :second_line]
  end

  private

    # returns a newly created address class
    def address_class(macro, *arguments)
      Class.new(ActiveRecord::Base) do
        self.table_name = 'addresses'
        send(macro, *arguments)
      end
    end

    # assert that the output to $stderr matches the expected
    def assert_output_matches(expected)
      stderr = $stderr
      $stderr = StringIO.new
      AttributeExtras.instance_variable_set(:@logger, Logger.new($stderr))
      yield
      assert_match expected, $stderr.string
    ensure
      $stderr = stderr
    end
end
