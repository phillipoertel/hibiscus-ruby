require 'hibiscus/money_string_parser'
require 'hibiscus/statement_line/validator'

module Hibiscus
  
  class StatementLine < Resource

    attr_reader :attrs

    class << self

      def requests
        {
          search: '/umsaetze/query/{term}',
          latest: '/konto/{account-id}/umsaetze/days/{days}'
        }
      end

      def map_response_data(attrs)
        {}.tap do |mapped_attrs| 
          mapped_attrs[:type]     = attrs["art"] # TODO use type constants that can be i18ned instead.
          amount_in_cents = MoneyStringParser.to_cents(attrs["betrag"])
          mapped_attrs[:amount]   = Money.new(amount_in_cents, 'EUR') # only EUR supported atm.
          mapped_attrs[:checksum] = attrs["checksum"]
          mapped_attrs[:customerref] = attrs["customerref"]
          mapped_attrs[:date] = Date.parse(attrs["datum"])
          mapped_attrs[:recipient_bic] = attrs["empfaenger_blz"]
          mapped_attrs[:recipient_name] = attrs["empfaenger_name"]
          mapped_attrs[:recipient_account] = attrs["empfaenger_konto"]
          mapped_attrs[:gvcode] = attrs["gvcode"] # what's this?
          mapped_attrs[:id] = attrs["id"].to_i
          mapped_attrs[:account_id] = attrs["konto_id"].to_i
          mapped_attrs[:primanota] = attrs["primanota"]
          balance_in_cents = MoneyStringParser.to_cents(attrs["saldo"])
          mapped_attrs[:balance] = Money.new(balance_in_cents, 'EUR') # only EUR supported atm.
          mapped_attrs[:valuta] = Date.parse(attrs["valuta"])
          mapped_attrs[:reference] = extract_reference(attrs)
        end
      end

      private

        def extract_reference(attrs)
          fields = attrs.select { |k, v| k =~ /\Azweck/ }
          fields.to_a.sort { |a1, a2| a1.first <=> a2.first }.map(&:last).join("\n")
        end
    end

    def search(term)
      response = get(path_for(:search).gsub('{term}', term.to_s))
      response.map { |attrs| self.class.new_from_response(attrs) }
    end
    
    def latest(account_id, days = 30)
      response = get(path_for(:latest).gsub('{account-id}', account_id.to_s).gsub('{days}', days.to_s))
      response.map { |attrs| self.class.new_from_response(attrs) }
    end

  end
end