module AttributeExtras
  module BaseExtensions

    # overrides the writer to truncate if that value is blank
    def truncate_attributes(*attributes, validator: false, writer: true)
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

        if validator
          validates attribute, length: { maximum: limit }
        end

        if writer
          define_method("#{attribute}=") do |value|
            write_attribute(attribute, ::AttributeExtras::TruncateAttributes::FUNCTION[value, limit: limit])
          end
        end

        truncated_attributes << Modifier.new(attribute, limit: limit)
      end
    end

  end
end

ActiveRecord::Base.extend AttributeExtras::BaseExtensions
