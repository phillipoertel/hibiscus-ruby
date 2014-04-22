require 'money'
require 'hibiscus/money_string_parser'

module Hibiscus
  class Account < Resource
    class Mapper

      def perform(attrs)
        {}.tap do |mapped_attrs| 

          mapped_attrs[:id]              = attrs["id"].to_i
          mapped_attrs[:bic]             = attrs["bic"]
          mapped_attrs[:label]           = attrs["bezeichnung"]
          mapped_attrs[:iban]            = attrs["iban"]
          mapped_attrs[:customer_number] = attrs["kundennummer"]
          mapped_attrs[:holder_name]     = attrs["name"]

          if attrs["saldo"]
            cents = MoneyStringParser.to_cents(attrs["saldo"])
            mapped_attrs[:balance]       = Money.new(cents, attrs["waehrung"])
          end

          if attrs["saldo_datum"]
            mapped_attrs[:balance_date]  = Time.parse(attrs["saldo_datum"])
          end
        end
      end # perform
      
    end
  end
end
