require 'hibiscus-ruby/resource'

module Hibiscus
  
  class Jobs < Resource

    PATHS = {
      pending: '/jobs/list'
    }

    def pending
      get(PATHS[:pending])
    end

  end
end