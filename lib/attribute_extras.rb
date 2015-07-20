require 'attribute_extras/extra_builder'
require 'attribute_extras/hook_builder'
require 'attribute_extras/modifier'

module AttributeExtras

  # the registered extras
  mattr_accessor :extras
  self.extras = []

  # wrap up configuration options into one block
  def self.configure(&block)
    yield self
  end

  # register the extra and build the functions
  def self.register_extra(verb, function, past:, validator:, options: nil)
    past ||= verb
    compiled_validator = validator.is_a?(Proc) ? validator : ->(options){ validator }
    options ||= ->(attribute){ {} }

    extra = ExtraBuilder.new(verb, past, function, compiled_validator, options).build
    hook = HookBuilder.new(verb, past).build

    self.const_set(:"#{verb.capitalize}Attributes", extra)
    self.extras << extra
    ActiveRecord::Base.extend(hook)
  end

  self.register_extra :nullify, ->(value, options){ value.presence },
    past: :nullified,
    validator: { format: { allow_nil: true, without: /\A\s*\z/ } }

  self.register_extra :strip, ->(value, options){ value.is_a?(String) ? value.strip : value },
    past: :stripped,
    validator: { format: { without: /\A\s+|\s+\z/ } }

  self.register_extra :truncate, ->(value, options){ value.is_a?(String) ? value[0...options[:limit]] : value },
    past: :truncated,
    validator: ->(options){ { length: { maximum: options[:limit] } } },
    options: ->(attribute){ { limit: self.columns_hash[attribute.to_s].limit } }

end
