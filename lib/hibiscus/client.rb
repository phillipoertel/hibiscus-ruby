require 'singleton'
require 'httparty'
require 'json'

module Hibiscus
  class Client

    attr_writer :config

    include Singleton

    def get(path, options = {})
      json = http_lib.get(request_uri(path), request_options.merge(options))
      JSON.parse(json)
    end

    def http_lib
      config[:http_lib] || HTTParty
    end

    def config
      @config || {}
    end

    private

      def request_uri(path)
        @config[:base_uri] ? URI.join(@config[:base_uri], path).to_s : path
      end

      def request_options
        options = {}
        options[:verify] = config[:verify] unless config[:verify].nil? # no SSL cert check
        if config[:username] && config[:password]
          options[:basic_auth] = {
            :username => config[:username], 
            :password => config[:password]
          }
        end
        options
      end

  end
end