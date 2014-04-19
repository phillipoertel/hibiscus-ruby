require 'hibiscus/statement_line/validator'

module Hibiscus
  
  class StatementLine < Resource

    attr_reader :attrs

    PATHS = {
      search: '/umsaetze/query/{term}',
      latest: '/konto/{account-id}/umsaetze/days/{days}'
    }

    # create an instance from API response attributes (which need to be mapped)
    def new_from_response(attrs)
      mapped_attrs = {}
      mapped_attrs[:id]               = attrs["id"].to_i
      object = new(mapped_attrs)
      
      if object.valid?
        object
      else
        raise Hibiscus::Resource::InvalidResponseData, object.errors.messages
      end
    end

    def search(term)
      get(PATHS[:search].gsub('{term}', term.to_s))
    end
    
    def latest(account_id, days = 30)
      get(PATHS[:latest].gsub('{account-id}', account_id.to_s).gsub('{days}', days.to_s))
    end

  end
end