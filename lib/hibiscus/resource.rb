require 'hibiscus/client'

module Hibiscus
  class Resource
    
    def get(*args)
      client.get(*args)
    end

    def post(*args)
      client.post(*args)
    end

    def client
      if true #ENV['LIVE']
        Client.instance
      else
        raise "TODO" # TODO implement fake client for debugging
        #require 'hibiscus/fake_party'
        #FakeClient.instance
      end
    end
    
  end
end