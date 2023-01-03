# AttributeExtras

[![Build Status](https://github.com/kddnewton/attribute_extras/workflows/Main/badge.svg)](https://github.com/kddnewton/attribute_extras/actions)
[![Gem](https://img.shields.io/gem/v/attribute_extras.svg)](https://rubygems.org/gems/attribute_extras)

Use this gem for automatic behavior on attributes performed before validation. You can use the predefined extras or define your own.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "attribute_extras"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install attribute_extras

## Usage

`AttributeExtras` provides three extras that are predefined: `nullify_attributes`, `strip_attributes`, and `truncate_attributes`. You can use these methods to tell `AttributeExtras` to perform mutations before validation. Additionally, you can call these methods at any time to perform the mutation programmatically. Examples are below:

### `ActiveRecord::Base::nullify_attributes`

Sets the value to `nil` if the value is blank.

```ruby
class Person < ActiveRecord::Base
  nullify_attributes :name
end

person = Person.create(name: '   ')
person.name # => nil

person = Person.new(name: '   ')
person.nullify_attributes
person.name # => nil
```

### `ActiveRecord::Base::strip_attributes`

Strips the value.

```ruby
class Person < ActiveRecord::Base
  strip_attributes :name
end

person = Person.create(name: '   value   ')
person.name # => 'value'

person = Person.new(name: '   value   ')
person.strip_attributes
person.name # => 'value'
```

### `ActiveRecord::Base::truncate_attributes`

Truncates the value to the maximum length allowed by the column.

```ruby
class Person < ActiveRecord::Base
  truncate_attributes :name
end

person = Person.create(name: 'a' * 500)
person.name # => 'a' * limit

person = Person.new(name: 'a' * 500)
person.truncate_attributes
person.name # => 'a' * limit
```

### `AttributeExtras::define_extra`

You can define your own extras by using the `define_extra` method on the `AttributeExtras` module. `define_extra` takes a name for the extra and a block which itself accepts three arguments (the record being modified, the attribute being modified, and the value of the attribute). The block should return the modified value. An example would be:

```ruby
AttributeExtras.define_extra :double_attributes do |_record, _attribute, value|
  value * 2
end

class Person < ActiveRecord::Base
  double_attributes :age
end

person = Person.create(age: 5)
person.age # => 10

person = Person.new(age: 5)
person.double_attributes
person.age # => 10
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kddnewton/attribute_extras.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
