module AttributeExtras

  # Builds a concern that will be included into classes when they call
  # the macro corresponding to the given verb. For instance, for the verb
  # :nullify it will build out AttributeExtras::NullifyAttributes, which
  # can be included into classes to get all of the utility functions.
  class ExtraBuilder

    # store the given options
    def initialize(verb, past, function, validator, options)
      @verb = verb
      @past = past
      @function = function
      @validator = validator
      @options = options
    end

    # build the extra
    def build
      concern = Module.new
      concern.module_eval(concern_definition)
      concern::ClassMethods.module_eval(&utilities_definition)
      concern
    end

    private

      # the module definition for the concern
      def concern_definition
        <<-RUBY
          extend ActiveSupport::Concern

          module ClassMethods
            def inherited_#{@past}_attributes
              @inherited_#{@past}_attributes ||= begin
                modifiers = []
                self.ancestors.each do |ancestor|
                  break if ancestor == ActiveRecord::Base
                  if ancestor.respond_to?(:#{@past}_attributes)
                    modifiers += ancestor.#{@past}_attributes
                  end
                end
                modifiers
              end
            end

            def #{@past}_attributes
              @#{@past}_attributes ||= []
            end
          end

          def #{@verb}_attributes
            set_#{@past}_attributes
            self.changed? ? self.save : true
          end

          def #{@verb}_attributes!
            set_#{@past}_attributes
            self.changed? ? self.save : true
          end

          private

            def set_#{@past}_attributes
              self.class.inherited_#{@past}_attributes.each do |modifier|
                attribute = modifier.attribute
                self.send(:\"\#{attribute}=\", self.class.#{@verb}_attribute_extra(self.send(attribute), modifier.options))
              end
            end
        RUBY
      end

      # the module definition for the utilities
      def utilities_definition
        verb, function, validator, options = @verb, @function, @validator, @options
        proc do
          define_method(:"#{verb}_attribute_extra", function)
          define_method(:"#{verb}_validator_for", validator)
          define_method(:"#{verb}_options_for", options)
        end
      end
  end
end
