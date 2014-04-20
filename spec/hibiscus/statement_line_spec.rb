require 'spec_helper'
require 'hibiscus/resource'
require 'hibiscus/statement_line'

module Hibiscus
  describe StatementLine do

    let(:line) { StatementLine.new }

    describe "API methods" do
  
      describe "#latest" do  
        it "calls GET on the client with correct URL" do
          client = double('Client')
          client.should_receive(:get).with('/konto/42/umsaetze/days/5').and_return([])
          line.stub(:client) { client }
          line.latest(42, 5)
        end
      end

      describe "#search" do
        it "calls GET on the client with correct URL" do
          client = double('Client')
          client.should_receive(:get).with('/umsaetze/query/paypal').and_return([])
          line.stub(:client) { client }
          line.search("paypal")
        end
      end
    end

  end
end