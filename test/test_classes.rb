COLUMN_LIMIT = 255
NUMBERS = %w[one two three four]

ActiveRecord::Schema.define do
  create_table :people, force: true do |t|
    %w[nullified stripped truncated].each do |prefix|
      options = (prefix == 'truncated') ? { limit: COLUMN_LIMIT } : {}
      NUMBERS.each do |number|
        t.string "person_#{prefix}_#{number}", options
      end
      t.string "architect_#{prefix}", options
    end
  end

  create_table :addresses, force: true do |t|
    t.string :first_line, limit: COLUMN_LIMIT
    t.string :second_line, limit: COLUMN_LIMIT
  end
end

class Person < ActiveRecord::Base

  { nullified: :nullify_attributes, stripped: :strip_attributes, truncated: :truncate_attributes }.each do |prefix, macro|
    NUMBERS.each_with_index do |number, index|
      send(macro, "person_#{prefix}_#{number}".to_sym, validator: (index / 2).even?, writer: (index % 2))
    end
  end

  def set_blank_attributes
    NUMBERS.each do |number|
      write_attribute("person_nullified_#{number}", '   ')
    end
    save(validate: false)
  end

  def set_long_attributes
    NUMBERS.each do |number|
      write_attribute("person_truncated_#{number}", self.class.long_value)
    end
    save(validate: false)
  end

  def set_padded_attributes
    NUMBERS.each do |number|
      write_attribute("person_stripped_#{number}", '  test value  ')
    end
    save(validate: false)
  end

  class << self
    def short_value
      @short_value ||= ('a' * COLUMN_LIMIT)
    end

    def stripped_value
      @stripped_value ||= 'test value'
    end

    def long_value
      @long_value ||= ('a' * 500)
    end
  end
end

class Developer < Person; end

class Architect < Developer
  nullify_attributes :architect_nullified
  strip_attributes :architect_stripped
  truncate_attributes :architect_truncated

  def set_blank_attributes
    write_attribute(:architect_nullified, '   ')
    super
  end

  def set_long_attributes
    write_attribute(:architect_truncated, self.class.long_value)
    super
  end

  def set_padded_attributes
    write_attribute(:architect_stripped, '  test value  ')
    super
  end
end
