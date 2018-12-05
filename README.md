# AttributeExtras

Use this gem for automatic behavior on attributes. It provides three class macros that can be used for managing attributes: `nullify_attributes`, `strip_attributes`, and `truncate_attributes`.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'attribute_extras'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install attribute_extras

## Usage

### nullify_attributes

Causes attribute assignment to check for presence of the given value, and set the value accordingly.

```ruby
class Person < ActiveRecord::Base
  nullify_attributes :name
end

person = Person.create(name: '   ')
person.name # => nil
```

### strip_attributes

Causes string attribute assignment to strip the given value, and set the value accordingly.

```ruby
class Person < ActiveRecord::Base
  strip_attributes :name
end

person = Person.create(name: '   value   ')
person.name # => 'value'
```

### truncate_attributes

Causes string attribute assignment to be truncated down to the maximum allowed value for that column.

```ruby
class Person < ActiveRecord::Base
  truncate_attributes :name
end

person = Person.new(name: 'a' * 500)
person.name # => 'a' * limit
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kddeisz/attribute_extras.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
