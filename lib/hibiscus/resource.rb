require 'money'

module Hibiscus
  class Resource

    attr_reader :attrs

    class InvalidResponseData < StandardError; end

    class << self

      # create an instance from API response attributes (which need to be mapped)
      def new_from_response(attrs)
        mapped_attrs = map_response_data(attrs)
        object = new(mapped_attrs)
        if object.valid?
          object
        else
          raise Hibiscus::Resource::InvalidResponseData, object.errors.messages
        end
      end

    end

    def valid?
      validator_class = self.class.const_get("Validator")
      @validator = validator_class.new(@attrs)
      @validator.valid?
    end

    def initialize(attrs = {})
      # symbolize keys
      @attrs = Hash[attrs.map { |k,v| [k.to_sym, v] }]
    end

    def errors
      @validator ? @validator.errors : []
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