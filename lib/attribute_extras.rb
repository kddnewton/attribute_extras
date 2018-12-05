# frozen_string_literal: true

require 'attribute_extras/version'

# Extra macros for auto attribute manipulation.
module AttributeExtras
  class NullifyAttributes < Module
    attr_reader :attributes

    def initialize(attributes)
      @attributes = attributes
    end

    def included(base)
      nullified_attributes = attributes

      base.before_validation do
        nullified_attributes.each do |attribute|
          value = public_send(attribute)

          public_send(:"#{attribute}=", value.presence)
        end
      end
    end
  end

  class StripAttributes < Module
    attr_reader :attributes

    def initialize(attributes)
      @attributes = attributes
    end

    def included(base)
      stripped_attributes = attributes

      base.before_validation do
        stripped_attributes.each do |attribute|
          value = public_send(attribute)
          stripped = value.is_a?(String) ? value.strip : value

          public_send(:"#{attribute}=", stripped)
        end
      end
    end
  end

  class TruncateAttributes < Module
    attr_reader :attributes

    def initialize(attributes)
      @attributes = attributes
    end

    def included(base)
      truncated_attributes =
        attributes.map do |attribute|
          [attribute, base.columns_hash[attribute.to_s].limit]
        end

      base.before_validation do
        truncated_attributes.each do |(attribute, limit)|
          value = public_send(attribute)
          truncated = value.is_a?(String) ? value[0...limit] : value

          public_send(:"#{attribute}=", truncated)
        end
      end
    end
  end

  module Hook
    def nullify_attributes(*attributes)
      include NullifyAttributes.new(attributes)
    end

    def strip_attributes(*attributes)
      include StripAttributes.new(attributes)
    end

    def truncate_attributes(*attributes)
      include TruncateAttributes.new(attributes)
    end
  end
end

ActiveRecord::Base.extend(AttributeExtras::Hook)
