require 'hibiscus/resource'
require 'hibiscus/statement_line/validator'
require 'hibiscus/statement_line/mapper'

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