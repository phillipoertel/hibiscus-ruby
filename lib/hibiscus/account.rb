require 'hibiscus/account/validator'

module Hibiscus
  
  class Account < Resource

    class InvalidResponseData < StandardError; end

    attr_reader :attrs

    class << self

      # create an instance from API response attributes (which need to be mapped)
      def new_from_response(attrs)
        mapped_attrs = {}
        mapped_attrs[:id]               = attrs["id"].to_i
        mapped_attrs[:bic]              = attrs["bic"]
        mapped_attrs[:label]            = attrs["bezeichnung"]
        mapped_attrs[:iban]             = attrs["iban"]
        mapped_attrs[:customer_number]  = attrs["kundennummer"]
        mapped_attrs[:holder_name]      = attrs["name"]

        if attrs["saldo"]
          # we rely on hibiscus server passing the saldo in the format "[-]100.50"
          mapped_attrs[:balance]          = Money.new(attrs["saldo"].sub('.', ''), attrs["waehrung"])
        end
        if attrs["saldo_datum"]
          mapped_attrs[:balance_date]     = Time.parse(attrs["saldo_datum"])
        end

        object = new(mapped_attrs)
        if object.valid?
          object
        else
          raise InvalidResponseData, object.errors.messages
        end
      end

      def requests
        {
          all: '/konto/list'
        }
      end
    end

    def initialize(attrs = {})
      # symbolize keys
      @attrs = Hash[attrs.map { |k,v| [k.to_sym, v] }]
    end

    def valid?
      @validator = Validator.new(@attrs)
      @validator.valid?
    end

    def errors
      @validator ? @validator.errors : []
    end

    def path_for(action)
      self.class.requests[action]
    end

    # FIXME make this a class method
    def all
      response = get(path_for(:all))
      response.map { |attrs| self.class.new_from_response(attrs) }
    end

    #def info
    #def transfers
    #statement_lines

    private

      # dynamic attribute readers
      def method_missing(name)
        super unless @attrs.has_key?(name)
        @attrs[name]
      end

  end
end