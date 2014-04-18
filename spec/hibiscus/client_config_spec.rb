require 'spec_helper'
require 'hibiscus/client_config'

module Hibiscus
  describe Client::Config do

    def config_for_options(options = {})
      Hibiscus::Client::Config.generate(options)
    end

    context "defaults" do
      it "is initialized with default values" do
        config = config_for_options
        config[:basic_auth][:username].should == 'admin'
        config[:basic_auth][:password].should == nil
        config[:verify].should == false
        config[:base_uri].should == 'https://localhost:8080/webadmin/rest/hibiscus'
      end
    end

    context "setting username" do

      it "defaults to 'admin'" do
        config = config_for_options(password: 'foo')
        config[:basic_auth][:username].should == 'admin'
        config[:basic_auth][:password].should == 'foo'
      end

      it "can be set to an other value" do
        config = config_for_options(password: 'foo', username: 'fritz')
        config[:basic_auth][:username].should == 'fritz'
        config[:basic_auth][:password].should == 'foo'
      end

    end

    context "setting password" do

      it "has no default" do
        config = config_for_options
        config[:basic_auth].should_not have_key(:password)
      end

      it "can be set" do
        config = config_for_options(password: '123456')
        config[:basic_auth][:password].should == '123456'
        config[:basic_auth][:username].should == 'admin'
      end

    end

    context "setting verify_ssl" do

      it "is set to false by default" do
        config = config_for_options
        config[:verify].should == false
      end

      it "verify_ssl true sets true" do
        config = config_for_options(verify_ssl: true)
        config[:verify].should == true
      end

      it "verify_ssl nil sets false" do
        config = config_for_options(verify_ssl: nil)
        config[:verify].should == false
      end

      it "verify_ssl: false sets false" do
        config = config_for_options(verify_ssl: false)
        config[:verify].should == false
      end

    end

    context "setting base_uri" do

      it "defaults to https://localhost:8080/webadmin/rest/hibiscus" do
        config = config_for_options
        config[:base_uri].should == 'https://localhost:8080/webadmin/rest/hibiscus'
      end

      it "can be set to an other value" do
        base_uri_double = double('Some base URI')
        config = config_for_options(base_uri: base_uri_double)
        config[:base_uri].should == base_uri_double
      end
    end

  end

end