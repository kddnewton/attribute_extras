COLUMN_LIMIT = 255

ActiveRecord::Schema.define do
  create_table :people, force: true do |t|
    t.string :nullified_name
    t.string :other_nullified_name

    t.string :stripped_name
    t.string :other_stripped_name

    t.string :truncated_name, limit: COLUMN_LIMIT
    t.string :truncated_whiny_name, limit: COLUMN_LIMIT
    t.string :other_truncated_name, limit: COLUMN_LIMIT
  end

  create_table :addresses, force: true do |t|
    t.string :first_line, limit: COLUMN_LIMIT
    t.string :second_line, limit: COLUMN_LIMIT
  end
end

class Person < ActiveRecord::Base
  nullify_attributes :nullified_name
  strip_attributes :stripped_name
  truncate_attributes :truncated_name
  truncate_attributes :truncated_whiny_name, whiny: true

  def set_blank_attributes
    write_attribute(:nullified_name, '   ')
    save
  end

  def set_long_attributes
    write_attribute(:truncated_name, self.class.long_value)
    write_attribute(:truncated_whiny_name, self.class.long_value)
    save(validate: false)
  end

  def set_padded_attributes
    write_attribute(:stripped_name, '  test value  ')
    save
  end

  class << self
    def short_value
      @short_value ||= ('a' * COLUMN_LIMIT)
    end

    def long_value
      @long_value ||= ('a' * 500)
    end
  end
end

class Developer < Person; end

class Architect < Developer
  nullify_attributes :other_nullified_name
  strip_attributes :other_stripped_name
  truncate_attributes :other_truncated_name

  def set_blank_attributes
    write_attribute(:nullified_name, '   ')
    write_attribute(:other_nullified_name, '   ')
    save
  end

  def set_long_attributes
    write_attribute(:truncated_name, self.class.long_value)
    write_attribute(:truncated_whiny_name, self.class.long_value)
    write_attribute(:other_truncated_name, self.class.long_value)
    save
  end

  def set_padded_attributes
    write_attribute(:stripped_name, '  test value  ')
    write_attribute(:other_stripped_name, '  test value  ')
    save
  end
end
