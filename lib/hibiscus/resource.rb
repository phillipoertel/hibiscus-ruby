module Hibiscus
  class Resource

    attr_reader :attrs

    class InvalidResponseData < StandardError; end

    class << self

      #
      # Creates an instance from API response attributes.
      # Maps and validates the attributes, then returns a new instance of the correct type
      #
      # raises Hibiscus::Resource::InvalidResponseData when attributes are invalid.
      #
      def new_from_response(response_attrs)
        mapped_attrs = mapper.perform(response_attrs)
        object = new(mapped_attrs)
        if object.valid?
          object
        else
          raise Hibiscus::Resource::InvalidResponseData, object.errors.messages
        end
      end

      # get the correct Mapper instance for my subclass (example: Hibiscus::Acount::Mapper)
      def mapper
        klass = self.const_get("Mapper")
        klass.new
      end

    end # end self

    # get the correct Validator instance for my subclass (example: Hibiscus::Acount::Validator)
    def validator
      @validator ||= begin
        klass = self.class.const_get("Validator")
        klass.new(@attrs)
      end
    end
    
    def valid?
      validator.valid?
    end

    def errors
      validator.errors
    end

    def initialize(attrs = {})
      # symbolize keys
      @attrs = Hash[attrs.map { |k,v| [k.to_sym, v] }]
    end

    def path_for(action)
      self.class.requests[action]
    end

    def get(*args)
      client.get(*args)
    end

    def post(*args)
      client.post(*args)
    end

    def client
      Client.instance
    end
   
    private

      # dynamic attribute readers
      def method_missing(name)
        super unless @attrs.has_key?(name)
        @attrs[name]
      end

  end
end