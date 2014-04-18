require 'spec_helper'
require 'hibiscus/client'

module Hibiscus
  describe Client do

    let(:klass) { Hibiscus::Client }
    let(:instance) { Hibiscus::Client.instance }

    it "is a singleton" do
      Hibiscus::Client.instance.should == Hibiscus::Client.instance
      expect { klass.new }.to raise_error(NoMethodError, /private method/)
    end

    describe "configuration" do

      it "can be set on the class" do
        klass.config = {password: "123456"}
        instance.config[:basic_auth][:password].should == "123456"
      end

      it "uses Hibiscus::Client::Config to generate config" do
        options = double('User given config')
        config  = double('Parsed hibiscus config')
        Hibiscus::Client::Config.should_receive(:generate).with(options).and_return(config)
        klass.config = options
        klass.config.should == config
      end
    end

    describe "response parsing" do
      
      before { instance.stub(:config) { {} } }

      it "returns JSON responses parsed" do
        instance.http_lib.stub(:get) { '{"hello": "world"}' }
        instance.get('/path').should == {"hello" => "world"}
      end

      it "raises an exception when JSON can't be parsed" do
        instance.http_lib.stub(:get) { '{hello: "world"}' } # JSON requires double quotes everywhere
        expect { instance.get('/path') }.to raise_error(JSON::ParserError, /unexpected token/)
      end
    end

    describe "requests" do

      before { instance.stub(:config) { {} } }

      describe "get" do
        context "path /path requested" do
          it "does a get on the http_lib" do
            instance.http_lib.should_receive(:get).with('/path', {}).and_return('{}')
            instance.get('/path')
          end
        end
      end

      describe "post" do
        context "no POST data given" do
          it "doesen't pass body" do
            instance.http_lib.should_receive(:post).with('/path', {body: {}}).and_return('{}')
            instance.post('/path')
          end
        end
        context "POST data given" do
          it "passes data as body" do
            data = {hello: "world"}
            instance.http_lib.should_receive(:post).with('/path', {body: data}).and_return('{}')
            instance.post('/path', data)
          end
        end
      end

    end

  end
end