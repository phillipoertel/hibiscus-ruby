require 'hibiscus/money_string_parser'
require 'hibiscus/account/validator'

module Hibiscus
  
  class Account < Resource

    class << self

      def requests
        {
          all: '/konto/list'
        }
      end

      def map_response_data(attrs)
        {}.tap do |mapped_attrs| 

          mapped_attrs[:id]              = attrs["id"].to_i
          mapped_attrs[:bic]             = attrs["bic"]
          mapped_attrs[:label]           = attrs["bezeichnung"]
          mapped_attrs[:iban]            = attrs["iban"]
          mapped_attrs[:customer_number] = attrs["kundennummer"]
          mapped_attrs[:holder_name]     = attrs["name"]

          if attrs["saldo"]
            # we rely on hibiscus server passing the saldo in the format "[-]100.50"
            cents = MoneyStringParser.to_cents(attrs["saldo"])
            mapped_attrs[:balance]       = Money.new(cents, attrs["waehrung"])
          end

          if attrs["saldo_datum"]
            mapped_attrs[:balance_date]  = Time.parse(attrs["saldo_datum"])
          end
        end
      end

    end

    # FIXME make this a class method
    def all
      response = get(path_for(:all))
      response.map { |attrs| self.class.new_from_response(attrs) }
    end

  end
end