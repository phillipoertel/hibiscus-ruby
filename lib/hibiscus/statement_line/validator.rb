require 'active_model'
I18n.enforce_available_locales = false

module Hibiscus
  class StatementLine < Resource
    class Validator

      include ActiveModel::Validations

      # FIXME dry up 
      class MoneyValidator < ActiveModel::EachValidator
        def validate_each(record, attribute, value)
          record.errors.add attribute, "must be a money object" unless value.is_a?(Money)
        end
      end

      # FIXME dry up 
      class DateValidator < ActiveModel::EachValidator
        def validate_each(record, attribute, value)
          record.errors.add attribute, "must be a date object" unless value.is_a?(Date)
        end
      end

      # FIXME dry up 
      class BicValidator < ActiveModel::EachValidator
        def validate_each(record, attribute, value)
          unless value && (value.match(/\A[A-Z]{8}\z/) || value.match(/\A[A-Z]{11}\z/))
            record.errors.add attribute, "BIC must be 8 or 11 characters in the range A-Z"
          end
        end
      end

      validates :type, presence: true
      validates :amount, money: true
      validates :checksum, presence: true
      validates :date, date: true
      validates :recipient_bic, bic: true
      validates :recipient_name, presence: true
      validates :recipient_account, presence: true
      validates :id, numericality: true
      validates :account_id, numericality: true
      validates :balance, money: true
      validates :valuta, date: true
      validates :reference, presence: true

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