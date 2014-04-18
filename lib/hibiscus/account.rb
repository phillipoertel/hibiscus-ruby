module Hibiscus
  
  class Account < Resource

    attr_accessor :id, :bic, :label, :iban, :customer_number, :holder_name, :balance, :balance_date

    class MoneyValidator < ActiveModel::EachValidator
      def validate_each(record, attribute, value)
        record.errors.add attribute, "must be a money object" unless value.is_a?(Money)
      end
    end

    validates :id, numericality: true
    validates :id, inclusion: (1..1_000)
    validates :bic, format: /\A[A-Z]{8,11}\z/
    # simple IBAN format check taken from http://goo.gl/xsNXen:
    # - the leading two characters must be letters, the rest numbers
    # - total length is between 15 (Norway) and 31 (Malta) characters
    validates :iban, format: /\A[A-Z]{2}[0-9]{13,29}\z/
    validates :label, presence: true
    validates :customer_number, numericality: true
    validates :holder_name, presence: true
    validates :balance, money: true
    validates :balance_date, presence: true

    def initialize(attrs = {})
      unless attrs.empty? # TEMP HACK
        @id               = attrs["id"].to_i
        @bic              = attrs["bic"]
        @label            = attrs["bezeichnung"]
        @iban             = attrs["iban"]
        @customer_number  = attrs["kundennummer"]
        @holder_name      = attrs["name"]
        # we rely on hibiscus server passing the saldo in the format "[-]100.50"
        @balance          = Money.new(attrs["saldo"].sub('.', ''), attrs["waehrung"])
        @balance_date     = Time.parse(attrs["saldo_datum"])
      end
    end

    def self.requests
      {
        all: '/konto/list'
      }
    end

    def path_for(action)
      self.class.requests[action]
    end

    def all
      response = get(path_for(:all))
      response.map { |attrs| self.class.new(attrs) }
    end

    #def info
    #def transfers
    #statement_lines

  end
end