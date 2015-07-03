require 'test_helper'

class ModifierTest < ActiveSupport::TestCase
  def test_modifiers
    modifier = AttributeExtras::Modifier.new(:name, limit: 255)
    assert_equal modifier.attribute, :name
    assert_equal modifier.options, { limit: 255 }
  end
end
