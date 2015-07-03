module AttributeExtras
  module StripAttributes

    extend ActiveSupport::Concern

    module ClassMethods
      # inherited and current stripped attributes
      def inherited_stripped_attributes
        @inherited_stripped_attributes ||= begin
          modifiers = []
          self.ancestors.each_with_object([]) do |ancestor|
            break if ancestor == ActiveRecord::Base
            if ancestor.respond_to?(:stripped_attributes)
              modifiers += ancestor.stripped_attributes
            end
          end
          modifiers
        end
      end

      # the stripped attributes for this class
      def stripped_attributes
        @stripped_attributes ||= []
      end
    end

    # calls set_stripped_attributes then save
    def strip_attributes
      set_stripped_attributes
      self.save if self.changed?
    end

    # calls set_stripped_attributes then save!
    def strip_attributes!
      set_stripped_attributes
      self.save! if self.changed?
    end

    private

      # apply the strip to each specified stripped attribute
      def set_stripped_attributes
        self.class.inherited_stripped_attributes.each do |modifier|
          attribute = modifier.attribute
          self.send("#{attribute}=", self.send(attribute))
        end
      end
  end
end
