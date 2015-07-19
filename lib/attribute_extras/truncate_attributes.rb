module AttributeExtras
  module TruncateAttributes

    extend ActiveSupport::Concern

    module ClassMethods
      # inherited and current truncated attributes
      def inherited_truncated_attributes
        @inherited_truncated_attributes ||= begin
          modifiers = []
          self.ancestors.each_with_object([]) do |ancestor|
            break if ancestor == ActiveRecord::Base
            if ancestor.respond_to?(:truncated_attributes)
              modifiers += ancestor.truncated_attributes
            end
          end
          modifiers
        end
      end

      # the truncated attributes for this class
      def truncated_attributes
        @truncated_attributes ||= []
      end
    end

    # calls set_truncated_attributes then save
    def truncate_attributes
      set_truncated_attributes
      self.changed? ? self.save : true
    end

    # calls set_truncated_attributes then save!
    def truncate_attributes!
      set_truncated_attributes
      self.changed? ? self.save! : true
    end

    private

      # apply the truncation to each specified truncated attribute
      def set_truncated_attributes
        self.class.inherited_truncated_attributes.each do |modifier|
          value = self.send(modifier.attribute)
          self.send("#{modifier.attribute}=", value.is_a?(String) ? value[0...modifier.options[:limit]] : value)
        end
      end
  end
end
