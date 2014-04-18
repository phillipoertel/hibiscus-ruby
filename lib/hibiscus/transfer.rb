module Hibiscus
  
  class Transfer < Resource

    PATHS = {
      delete:  '/ueberweisung/delete/{id}',
      pending: '/ueberweisung/list/open',
      create:  '/ueberweisung/create'
    }

    def delete(id)
      get(PATHS[:delete].gsub('{id}', id.to_s))
    end

    def pending
      get(PATHS[:pending])
    end

    # FIXME does not work yet
    def create(data)
      post(PATHS[:create], data)
    end

  end
end