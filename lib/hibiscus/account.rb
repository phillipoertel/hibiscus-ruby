require 'hibiscus/resource'
require 'hibiscus/account/validator'
require 'hibiscus/account/mapper'

module Hibiscus
  
  class Account < Resource

    class << self

      def requests
        {
          all: '/konto/list'
        }
      end

    end

    # FIXME make this a class method
    def all
      response = get(path_for(:all))
      response.map { |attrs| self.class.new_from_response(attrs) }
    end

  end
end