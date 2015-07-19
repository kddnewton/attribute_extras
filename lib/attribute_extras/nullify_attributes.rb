module AttributeExtras
  module NullifyAttributes

    REGEXP = /\A\s*\z/.freeze

    extend ActiveSupport::Concern

    module ClassMethods
      # inherited and current nullified attributes
      def inherited_nullified_attributes
        @inherited_nullified_attributes ||= begin
          modifiers = []
          self.ancestors.each_with_object([]) do |ancestor|
            break if ancestor == ActiveRecord::Base
            if ancestor.respond_to?(:nullified_attributes)
              modifiers += ancestor.nullified_attributes
            end
          end
          modifiers
        end
      end

      # the nullified attributes for this class
      def nullified_attributes
        @nullified_attributes ||= []
      end
    end

    # calls set_nullified_attributes then save
    def nullify_attributes
      set_nullified_attributes
      self.changed? ? self.save : true
    end

    # calls set_nullified_attributes then save!
    def nullify_attributes!
      set_nullified_attributes
      self.changed? ? self.save! : true
    end

    private

      # apply the nullification to each specified nullified attribute
      def set_nullified_attributes
        self.class.inherited_nullified_attributes.each do |modifier|
          attribute = modifier.attribute
          self.send("#{attribute}=", self.send(attribute).presence)
        end
      end
  end
end
