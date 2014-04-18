module Hibiscus
  class Resource
    
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