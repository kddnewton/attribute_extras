module AttributeExtras

  # Builds a module that extends ActiveRecord::Base to build the macro
  # corresponding to the given verb. For instance, for the verb :nullify,
  # it will build a module that extends AR::Base with the method
  # :nullify_attributes, which is then used to include the concern from
  # the ExtraBuilder.
  class HookBuilder

    # store the given options
    def initialize(verb, past)
      @verb = verb
      @past = past
    end

    # build the hook
    def build
      hook = Module.new
      hook.module_eval(module_definition)
      hook
    end

    private

      # the module definition for the extra
      def module_definition
        <<-RUBY
          def #{@verb}_attributes(*attributes, validator: true, writer: true)
            if !self.table_exists? || (non_attributes = attributes.map(&:to_s) - self.column_names).any?
              AttributeExtras.logger.warn("Invalid attributes passed to #{@verb}_attributes: \#{non_attributes.join(', ')}")
              return
            end

            include ::AttributeExtras::#{@verb.capitalize}Attributes

            attributes.each do |attribute|
              options = self.#{@verb}_options_for(attribute)
              modifier = Modifier.new(attribute, options)

              if validator
                validates attribute, self.#{@verb}_validator_for(modifier.options)
              end

              if writer
                define_method("\#{attribute}=") do |value|
                  write_attribute(attribute, self.class.#{@verb}_attribute_extra(value, modifier.options))
                end
              end

              #{@past}_attributes << modifier
            end
          end
        RUBY
      end
  end
end
