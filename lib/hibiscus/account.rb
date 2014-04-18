module Hibiscus
  
  class Account < Resource

    PATHS = {
      all: '/konto/list'
    }

    def all
      get(PATHS[:all])
    end

    #def info
    #def transfers
    #statement_lines

  end
end