require 'spec_helper'
require 'hibiscus/resource'
require 'hibiscus/account'

module Hibiscus
  describe Account do
    
    let(:account) { Hibiscus::Account.new }

    describe "API methods" do
      describe "#all" do
        it "calls GET on the client with correct URL" do
          client = double('Client')
          client.should_receive(:get).with('/konto/list').and_return([])
          account.stub(:client) { client }
          account.all
        end
      end
    end

  end

end