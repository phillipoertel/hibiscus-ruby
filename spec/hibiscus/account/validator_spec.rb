require 'spec_helper'
require 'hibiscus/resource'
require 'hibiscus/account'
require 'hibiscus/account/mapper'
require 'hibiscus/account/validator'

module Hibiscus
  describe Account::Validator do

    describe "dynamic attribute readers" do
      it "has methods for each attribute" do
        validator = Account::Validator.new(foo: "bar")
        validator.foo.should == "bar"
      end
      it "raises NoMethodError for unknown attributes" do
        validator = Account::Validator.new(foo: "bar")
        expect {validator.baz }.to raise_error(NoMethodError, /baz/)
      end
    end    

    let(:valid_attrs) do
      valid_api_response = {
        "bezeichnung"=>"Magic-Konto", 
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
      Account::Mapper.new.perform(valid_api_response)
    end

    context "correct API data given" do
      let(:attrs) { valid_attrs }
      it "is valid" do
        validator = Account::Validator.new(attrs)
        validator.should be_valid, validator.errors.messages
      end
    end

    context "BIC with 9 characters given (invalid)" do
      let(:attrs) { r = valid_attrs.dup; r[:bic] = "ABCABCABC"; r }
      it "is invalid" do
        validator = Account::Validator.new(attrs)
        validator.should_not be_valid
        validator.errors.messages.should == {:bic=>["BIC must be 8 or 11 characters in the range A-Z"]}
      end
    end

  end
end