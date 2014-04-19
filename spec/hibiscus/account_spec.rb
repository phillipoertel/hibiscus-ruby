require 'spec_helper'
require 'hibiscus/resource'
require 'hibiscus/account'

module Hibiscus
  describe Account do
    
    let(:account) { Hibiscus::Account.new }

    def stub_client_response(response)
      client_double = double('Client')
      client_double.stub(:get) { response }
      account.stub(:client).and_return(client_double)
    end

    describe "#valid?" do
      it "uses Account::Validator" do
        stub_client_response([])
        Account::Validator.should_receive(:new).with(account.attrs).and_call_original
        Account::Validator.any_instance.should_receive(:valid?)
        account.valid?
      end
    end

    describe "#all" do
      it "requests correct URL on client" do
        client_double = double('Client')
        client_double.should_receive(:get).with('/konto/list').and_return([])
        account.stub(:client).and_return(client_double)
        account.all
      end

      it "returns account objects" do
        client_double = double('Client')
        client_double.should_receive(:get).with('/konto/list').and_return([{}])
        account.stub(:client).and_return(client_double)
        account.all.first.should be_instance_of Hibiscus::Account
      end
      
    end

    # FIXME test these without going through #all
    describe "#all, returned response" do

      let(:valid_api_response) do
        [{"bezeichnung"=>"Magic-Konto", 
          "bic"=>"MYBANKXXXXX", 
          "blz"=>"12345678", 
          "iban"=>"AA12345678901234567890", 
          "id"=>"1", 
          "kontonummer"=>"1234567890", 
          "kundennummer"=>"47114711", 
          "name"=>"MUSTERMANN, MAX", 
          "passport_class"=>"de.willuhn.jameica.hbci.passports.pintan.server.PassportImpl", 
          "saldo"=>"-100.01", 
          "saldo_datum"=>"2014-04-17 09:10:50.0", 
          "waehrung"=>"EUR"
        }]
      end

      it "returns account objects" do
        stub_client_response(valid_api_response)
        first = account.all.first
        first.should be_instance_of Hibiscus::Account
      end

      it "maps api data correctly" do
        stub_client_response(valid_api_response)
        first = account.all.first
        first.id.should == 1
        first.bic.should == "MYBANKXXXXX"
        first.iban.should == "AA12345678901234567890"
        first.label.should == "Magic-Konto"
        first.customer_number.should == "47114711"
        first.holder_name.should == "MUSTERMANN, MAX"
        first.balance.cents.should == -10001
        first.balance.currency.should == "EUR"
        first.balance_date.should == Time.parse("2014-04-17 09:10:50.0")
      end

    end

    describe "dynamic attribute readers" do
      it "has methods for each attribute" do
        account = Account.new(foo: "bar")
        account.foo.should == "bar"
      end
      it "works when attribute keys are strings" do
        account = Account.new("foo" => "bar")
        account.foo.should == "bar"
      end
      it "raises NoMethodError for unknown attributes" do
        account = Account.new(foo: "bar")
        expect { account.baz }.to raise_error(NoMethodError, /baz/)
      end
    end    


 end

end