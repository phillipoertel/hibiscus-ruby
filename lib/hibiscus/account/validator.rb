require 'active_model'
I18n.enforce_available_locales = false

module Hibiscus
  class Account < Resource
    class Validator

      include ActiveModel::Validations
      
      class MoneyValidator < ActiveModel::EachValidator
        def validate_each(record, attribute, value)
          record.errors.add attribute, "must be a money object" unless value.is_a?(Money)
        end
      end

      validates :id, numericality: true
      validates :id, inclusion: (1..1_000)

      # TODO it's actually 8 OR 11 chars, not within.
      validates :bic, format: /\A[A-Z]{8,11}\z/

      # simple IBAN format check taken from http://goo.gl/xsNXen:
      # - the leading two characters must be letters, the rest numbers
      # - two digits with the checksum follow
      # - the remaining characters can be letters or numbers
      # - total length is between 15 (Norway) and 31 (Malta) characters
      validates :iban, format: /\A[A-Z]{2}[0-9]{2}[A-Z0-9]{11,27}\z/

      validates :label, presence: true
      validates :customer_number, numericality: true
      validates :holder_name, presence: true
      validates :balance, money: true
      validates :balance_date, presence: true

      def initialize(attrs = {})
        @attrs = attrs
      end

      private

        # dynamic attribute readers
        def method_missing(name)
          super unless @attrs.has_key?(name)
          @attrs[name]
        end

    end
  end
end