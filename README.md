## AttributeExtras

Use this gem for automatic behavior on attributes. It by default provides three class macros that can be used for managing attributes. You can also build your own macros that will automatically become available to you within your ActiveRecord models. By default each macro gets the options `:validator` and `:writer` and both are set to true. If you do not want the macros to validate or overwrite the attribute writers, you can pass false to those options.

### nullify_attributes

Causes attribute assignment to check for presence of the given value, and set the value accordingly.

```ruby
class Person < ActiveRecord::Base
  nullify_attributes :name
end

p = Person.new(name: '   ')
p.name # => nil
```

### strip_attributes

Causes string attribute assignment to strip the given value, and set the value accordingly.

```ruby
class Person < ActiveRecord::Base
  strip_attributes :name
end

p = Person.new(name: '   value   ')
p.name # => 'value'
```

### truncate_attributes

Causes string attribute assignment to be truncated down to the maximum allowed value for that column.

```ruby
class Person < ActiveRecord::Base
  truncate_attributes :name
end

p = Person.new(name: 'a' * 500)
p.name # => 'a' * limit
```

### Inheritance

By default, attributes that you manipulate with any of the above macros will be inherited into the subclasses.

### Other methods

For migrating values to the correct format specified, there are two methods for each macro that will enforce the format. For example, for the `nullify_attributes` macro there is the `nullify_attributes` instance method and the `nullify_attributes!` instance method. Both will set the correct values and then call their respective `save`.

For introspection, there are two methods for each macro supplied. For example, for the `nullify_attributes` macro there is the `nullified_attributes` method and the `inherited_nullified_attributes` method. Examples below:

```ruby
class Person < ActiveRecord::Base
  nullify_attributes :name
end

class Developer < Person
  nullify_attributes :email
end

Person.nullified_attributes.map(&:attribute) # => [:name]
Person.inherited_nullified_attributes.map(&:attribute) # => [:name]

Developer.nullified_attributes.map(&:attribute) # => [:email]
Developer.inherited_nullified_attributes.map(&:attribute) # => [:email, :name]
```

## Internals

If you want to register your own macros, you can do so with `AttributeExtras.register_extra`. Internally `attribute_extras` does this for the three macros listed above.

### `:nullify` Example

```ruby
self.register_extra :nullify, ->(value, options){ value.presence },
  past: :nullified,
  validator: { format: { allow_nil: true, without: /\A\s*\z/ } }
```

### `:truncate` Example

```ruby
self.register_extra :truncate, ->(value, options){ value.is_a?(String) ? value[0...options[:limit]] : value },
  past: :truncated,
  validator: ->(options){ { length: { maximum: options[:limit] } } },
  options: ->(attribute){ { limit: self.columns_hash[attribute.to_s].limit } }
```

In this case the options is needed to build a hash of metadata about the attribute in question so that the validator option can change. The options hash is also passed in to the `truncate_attribute_extra` method so that you have access to that metadata.

## Additional information

### Contributing

Contributions welcome! Please submit a pull request with tests.

### Licence

MIT Licence.
