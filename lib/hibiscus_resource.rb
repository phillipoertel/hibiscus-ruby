require 'httparty'
require 'json'

class HibiscusResource
  
  if ENV['LIVE']
    include HTTParty
  else
    require_relative 'fake_party'
    include FakeParty
  end
  
  base_uri 'https://localhost:8080/webadmin/rest/hibiscus'

  def initialize(password)
    @password = password
  end

  private

    def get(path)
      json = self.class.get(path, request_options)
      JSON.parse(json)
    end
    
    def post(path, body)
      json = self.class.post(path, request_options.merge(body: body))
      JSON.parse(json)
    end
  
end