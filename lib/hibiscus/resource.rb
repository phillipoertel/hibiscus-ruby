require 'active_model'
require 'money'

I18n.enforce_available_locales = false

module Hibiscus
  class Resource

    include ActiveModel::Validations
    
    def get(*args)
      client.get(*args)
    end

    def post(*args)
      client.post(*args)
    end

    def client
      Client.instance
    end
    
  end
end