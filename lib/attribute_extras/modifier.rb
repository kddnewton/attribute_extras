module AttributeExtras

  # a container for an attribute that has been modified
  class Modifier

    attr_reader :attribute, :options

    def initialize(attribute, options = {})
      @attribute = attribute
      @options = options
    end

  end
end
