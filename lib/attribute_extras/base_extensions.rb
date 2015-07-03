module AttributeExtras
  module BaseExtensions

    # overrides the writer to set to nil if that value is blank
    def nullify_attributes(*attributes)
      if self.table_exists? and (non_attributes = attributes.map(&:to_s) - self.column_names).any?
        raise ArgumentError, "Invalid attributes passed to nullify_attributes: #{non_attributes.join(', ')}"
      end

      include ::AttributeExtras::NullifyAttributes

      attributes.each do |attribute|
        define_method("#{attribute}=") do |value|
          write_attribute(attribute, value.presence)
        end
        nullified_attributes << Modifier.new(attribute)
      end
    end

    # overrides the writer to strip the value
    def strip_attributes(*attributes)
      string_columns = self.columns.select { |column| column.type == :string }.map(&:name)
      if self.table_exists? and (non_attributes = attributes.map(&:to_s) - string_columns).any?
        raise ArgumentError, <<-MSG.squish
          Invalid attributes passed to strip_attributes: #{non_attributes.join(', ')};
          attributes must be string columns
        MSG
      end

      include ::AttributeExtras::StripAttributes

      attributes.each do |attribute|
        define_method("#{attribute}=") do |value|
          write_attribute(attribute, value.is_a?(String) ? value.strip : value)
        end
        stripped_attributes << Modifier.new(attribute)
      end
    end

    # overrides the writer to truncate if that value is blank
    def truncate_attributes(*attributes, whiny: false)
      string_columns = self.columns.select { |column| column.type == :string && !column.limit.nil? }.map(&:name)
      if self.table_exists? and (non_attributes = attributes.map(&:to_s) - string_columns).any?
        raise ArgumentError, <<-MSG.squish
          Invalid attributes passed to truncate_attributes: #{non_attributes.join(', ')};
          attributes must be string columns that have a set limit
        MSG
      end

      include ::AttributeExtras::TruncateAttributes

      truncated_attributes
      attributes.each do |attribute|
        limit = self.columns_hash[attribute.to_s].limit

        if whiny
          validates attribute, length: { maximum: limit }
          @truncated_attributes << Modifier.new(attribute, limit: limit)
        else
          define_method("#{attribute}=") do |value|
            write_attribute(attribute, value.is_a?(String) ? value[0...limit] : value)
          end
          @truncated_attributes << Modifier.new(attribute)
        end
      end
    end

  end
end

ActiveRecord::Base.extend AttributeExtras::BaseExtensions
