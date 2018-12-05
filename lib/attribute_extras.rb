# frozen_string_literal: true

require 'attribute_extras/version'

# Extra macros for auto attribute manipulation.
module AttributeExtras
  # Parent class of the various extras.
  class AttributeExtra < Module
    attr_reader :name

    def initialize(name, attributes, perform)
      @name = name
      define_extra(name, attributes, perform)
    end

    def included(clazz)
      clazz.before_validation(name)
    end

    private

    def define_extra(name, attributes, perform)
      define_method(name) do
        attributes.each do |attribute|
          value = public_send(attribute)
          public_send(:"#{attribute}=", perform[self, attribute, value])
        end
      end
    end
  end

  def self.define_extra(name, &perform)
    extra = Class.new(AttributeExtra)
    extra_name = name.to_s.gsub(/(?:\A|_)([a-z])/i) { $1.upcase }.to_sym

    AttributeExtras.const_set(extra_name, extra)
    ActiveRecord::Base.define_singleton_method(name) do |*attributes|
      include extra.new(name, attributes, perform)
    end
  end

  define_extra :nullify_attributes do |*, value|
    value.presence
  end

  define_extra :strip_attributes do |*, value|
    value.is_a?(String) ? value.strip : value
  end

  define_extra :truncate_attributes do |record, attribute, value|
    limit = record.class.columns_hash[attribute.to_s].limit
    value.is_a?(String) ? value[0...limit] : value
  end
end
