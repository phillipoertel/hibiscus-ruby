require 'active_model'
I18n.enforce_available_locales = false

module Hibiscus
  class StatementLine < Resource
    class Validator
      include ActiveModel::Validations

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