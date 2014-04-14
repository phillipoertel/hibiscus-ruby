require 'spec_helper'
require 'hibiscus/client'

module Hibiscus
  describe Client do
  
    let(:client) { Hibiscus::Client.instance }

    # client is the same instance for all tests in this process 
    before(:each) { client.config = {} }

    it "is a singleton" do
      Hibiscus::Client.instance.should == Hibiscus::Client.instance
      expect { Hibiscus::Client.new }.to raise_error(NoMethodError, /private method/)
    end

    describe "configuration" do

      context "setting username and password" do
        it "passes them as basic auth to requests" do
          config           = {:username => "admin", :password => "password" }
          expected_options = {basic_auth: config}
          client.http_lib.should_receive(:get).with('/path', expected_options).and_return("{}")
          client.config = config
          client.get('/path')
        end
      end

      context "setting verify" do
        it "doesn't set it by default" do
          client.http_lib.should_receive(:get).with('/path', {}).and_return("{}")
          client.get('/path')
        end
        it "passes it as-is" do
          config           = {verify: false}
          expected_options = config
          client.http_lib.should_receive(:get).with('/path', expected_options).and_return("{}")
          client.config = config
          client.get('/path')
        end
      end

      context "setting base_uri" do
        it "prefixes the requests with it" do
          client.config = {base_uri: "http://hello-world.org"}
          client.http_lib.should_receive(:get).with('http://hello-world.org/home', {}).and_return("{}")
          client.get("/home")
        end
        it "preserves the path on the base_uri when present" do
          client.config = {base_uri: "http://hello-world.org/foo/bar"}
          client.http_lib.should_receive(:get).with('http://hello-world.org/foo/bar/home', {}).and_return("{}")
          client.get("/home")
        end
        it "fixes double slashes" do
          client.config = {base_uri: "http://hello-world.org/foo/bar/"}
          client.http_lib.should_receive(:get).with('http://hello-world.org/foo/bar/home', {}).and_return("{}")
          client.get("/home")
        end
        it "uses the url as-is when base_uri is unset" do
          client.http_lib.should_receive(:get).with('http://hello-world.org/foo', {}).and_return("{}")
          client.get("http://hello-world.org/foo")
        end
      end

    end

    describe "response parsing" do
      
      it "returns JSON responses parsed" do
        client.http_lib.should_receive(:get).and_return('{"hello": "world"}')
        client.get('/path').should == {"hello" => "world"}
      end

      it "raises an exception when JSON can't be parsed" do
        client.http_lib.should_receive(:get).and_return('{hello: "world"}')
        expect { client.get('/path') }.to raise_error(JSON::ParserError, /unexpected token/)
      end
    end

    describe "requests" do

      describe "get" do
        context "path /path requested" do
          it "does a get on the http_lib" do
            client.http_lib.should_receive(:get).with('/path', {}).and_return('{}')
            client.get('/path')
          end
        end
      end

      describe "post" do
        context "path /path requested" do
          it "does a get on the http_lib, passes data as body" do
            data = {hello: "world"}
            client.http_lib.should_receive(:post).with('/path', {body: data}).and_return('{}')
            client.post('/path', data)
          end
        end
      end

    end

  end
end