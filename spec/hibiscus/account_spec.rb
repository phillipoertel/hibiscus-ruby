require 'spec_helper'
require 'hibiscus/resource'
require 'hibiscus/account'

module Hibiscus
  describe Account do
    
    let(:account) { Hibiscus::Account.new }

    describe "#valid?" do
      it "uses Account::Validator" do
        account.stub(:client)
        Account::Validator.should_receive(:new).with(account.attrs).and_call_original
        Account::Validator.any_instance.should_receive(:valid?)
        account.valid?
      end
    end

    # FIXME move this to a resource_spec (still to be created)
    describe "#validator" do
      it "caches the validator instance" do
        Account::Validator.should_receive(:new).once.and_call_original
        2.times { account.validator }
      end
    end

    # FIXME move this to a resource_spec (still to be created)
    describe "#errors" do
      it "is empty when not validated" do
        account.errors.should be_empty
      end
      it "is set when validated" do
        Account::Validator.any_instance.stub(:valid?)
        Account::Validator.any_instance.should_receive(:errors).and_return(["something"])
        account.valid?
        account.errors.should_not be_empty
      end
    end

    describe "#all" do
      it "calls GET on the client with correct URL" do
        client = double('Client')
        client.should_receive(:get).with('/konto/list').and_return([])
        account.stub(:client) { client }
        account.all
      end
    end

    describe ".new_from_response" do

      let(:valid_api_response) do
        {"bezeichnung"=>"Magic-Konto", 
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
        }
      end

      it "returns an account object" do
        account = Account.new_from_response(valid_api_response)
        account.should be_instance_of Hibiscus::Account
      end

      it "maps api data correctly" do
        account = Account.new_from_response(valid_api_response)
        account.id.should == 1
        account.bic.should == "MYBANKXXXXX"
        account.iban.should == "AA12345678901234567890"
        account.label.should == "Magic-Konto"
        account.customer_number.should == "47114711"
        account.holder_name.should == "MUSTERMANN, MAX"
        account.balance.cents.should == -10001
        account.balance.currency.should == "EUR"
        account.balance_date.should == Time.parse("2014-04-17 09:10:50.0")
      end

      it "raises an error when api data is invalid" do
        invalid = valid_api_response.dup
        invalid.delete("id")
        expect { Account.new_from_response(invalid) }.to raise_error(Account::InvalidResponseData, '{:id=>["is not included in the list"]}')
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