## AttributeExtras

Use this gem for automatic behavior on attributes. It provides three class macros that can be used for managing attributes.

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

Causes string attribute assignment to be truncated down to the maximum allowed value for that column. If `whiny` is set the to, instead adds a length validator on that attribute to cause it to error if saved.

```ruby
class Person < ActiveRecord::Base
  truncate_attributes :first_name
  truncate_attributes :last_name, whiny: true
end

p = Person.new(first_name: 'a' * 500, last_name: 'a' * 500)
p.first_name # => 'a' * limit
p.save! # => ActiveRecord::RecordInvalid: Validation failed
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

## Additional information

### Contributing

Contributions welcome! Please submit a pull request with tests.

### Licence

MIT Licence.
