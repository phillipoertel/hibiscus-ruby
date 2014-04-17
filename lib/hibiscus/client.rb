require 'singleton'
require 'httparty'
require 'json'

module Hibiscus
  
  class Client

    attr_writer :config

    include Singleton

    def get(path, options = {})
      http_request(:get, path, options)
    end

    def post(path, body = {})
      http_request(:post, path, {body: body})
    end

    def http_lib
      config[:http_lib] || HTTParty
    end

    def config
      @config || {}
    end

    private

      def http_request(method, path, options)
        uri     = request_uri(path)
        options = request_options.merge(options)
        #puts "#{method.upcase} #{uri}" # TODO remove
        json = http_lib.public_send(method, uri, options)
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

      def request_options
        {}.tap do |options|
          options[:verify] = !!config[:verify] if config.has_key?(:verify) # no SSL cert check if set to false
          if (config[:username] || config[:password])
            options[:basic_auth] = {}
            options[:basic_auth][:username] = config[:username] if config[:username]
            options[:basic_auth][:password] = config[:password] if config[:password]
          end
        end
      end

  end
end