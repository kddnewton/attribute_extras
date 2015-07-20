module AttributeExtras

  # a container for an attribute that has been modified
  class Modifier

    # the attribute this modifier represents
    attr_reader :attribute

    # the set of options generated for this attribute
    attr_reader :options

    # store the given options
    def initialize(attribute, options = {})
      @attribute = attribute
      @options = options
    end

  end
end
