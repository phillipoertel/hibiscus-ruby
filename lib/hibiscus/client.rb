require 'singleton'
require 'httparty'
require 'json'

module Hibiscus
  
  class Client

    attr_reader :config

    include Singleton

    def get(path, options = {})
      http_request(:get, path, options)
    end

    def post(path, body = {})
      http_request(:post, path, {body: body})
    end

    def http_lib
      HTTParty
    end

    def config=(options)
      @config = Config.generate(options)
    end

    # allows Hibiscus::Client.config = ...
    def self.config=(config)
      instance.config = config
    end

    def self.config
      instance.config
    end

    private

      def http_request(method, path, options)
        uri     = request_uri(path)
        options = config.merge(options)
        json = http_lib.public_send(method, uri, options)
        json.body.force_encoding(Encoding::ISO_8859_1).encode(Encoding::UTF_8)
        JSON.parse(json)
      end

      def request_uri(path)
        if config[:base_uri] 
          # URI.join wasn't helpful here, unfortunately (it removes the path component on base_uri)
          [config[:base_uri].sub(/\/?\Z/, ''), path.sub(/\A\/?/, '')].join('/')
        else
          path
        end
      end

  end
end