module Hibiscus
  class Client
    class Config

      attr_reader :options

      def self.generate(options = {})
        new.generate(options)
      end

      def generate(options)
        @options = options
        config = { basic_auth: {} }
        config[:basic_auth].merge!(username_config)
        config[:basic_auth].merge!(password_config)
        config.merge!(verify_ssl_config)
        config.merge!(base_uri_config)
      end

      private

        def verify_ssl_config
          verify = !!options.fetch(:verify_ssl, defaults[:verify])
          { verify: verify }
        end

        def username_config
          username = options.fetch(:username, defaults[:basic_auth][:username])
          { username: username }
        end

        def password_config 
          options.has_key?(:password) ? { password: options[:password] } : {}
        end

        def base_uri_config 
          uri = options.fetch(:base_uri, defaults[:base_uri])
          { base_uri: uri }
        end

        def defaults
          {
            basic_auth: { username: 'admin' },
            verify: false,
            base_uri: 'https://localhost:8080/webadmin/rest/hibiscus'
          }
        end

    end
  end
end