require 'spec_helper'
require 'hibiscus/resource'
require 'hibiscus/account'
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

    it "works" do
      # FIXME use attributes mapped by account here.
      attrs = {
        label: "Magic-Konto", 
        bic: "MYBANKXXXXX", 
        blz: "12345678", 
        iban: "AA12345678901234567890", 
        id:  1, 
        customer_number: "47114711", 
        holder_name: "MUSTERMANN, MAX", 
        balance:  Money.new("-100.01", "EUR"), 
        balance_date: "2014-04-17 09:10:50.0"
      }
      validator = Account::Validator.new(attrs)
      validator.should be_valid, validator.errors.messages
    end
  end
end