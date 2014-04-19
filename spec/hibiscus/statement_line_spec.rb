require 'spec_helper'
require 'hibiscus/resource'
require 'hibiscus/statement_line'

module Hibiscus
  describe StatementLine do

    let(:line) { StatementLine.new }

    describe "#valid?" do
      it "uses StatementLine::Validator" do
        line.stub(:client)
        StatementLine::Validator.should_receive(:new).with(line.attrs).and_call_original
        StatementLine::Validator.any_instance.should_receive(:valid?)
        line.valid?
      end
    end

    describe "#latest" do

      let(:lines) { StatementLine.new }

      it "calls GET on the client with correct URL" do
        client = double('Client')
        client.should_receive(:get).with('/konto/42/umsaetze/days/5').and_return([])
        line.stub(:client) { client }
        line.latest(42, 5)
      end
    end

    describe "#search" do

      let(:lines) { StatementLine.new }

      it "calls GET on the client with correct URL" do
        client = double('Client')
        client.should_receive(:get).with('/umsaetze/query/paypal').and_return([])
        line.stub(:client) { client }
        line.search("paypal")
      end
    end
  end
end