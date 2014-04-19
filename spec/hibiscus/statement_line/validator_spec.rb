require 'spec_helper'
require 'hibiscus/resource'
require 'hibiscus/statement_line'
require 'hibiscus/statement_line/validator'

module Hibiscus
  describe StatementLine::Validator do

    describe "dynamic attribute readers" do
      it "has methods for each attribute" do
        validator = StatementLine::Validator.new(foo: "bar")
        validator.foo.should == "bar"
      end
      it "raises NoMethodError for unknown attributes" do
        validator = StatementLine::Validator.new(foo: "bar")
        expect {validator.baz }.to raise_error(NoMethodError, /baz/)
      end
    end    

    let(:valid_attrs) do
      valid_api_response = {
        "art"=>"\xDCberweisung",
         "betrag"=>"-156.9",
         "checksum"=>"835255347",
         "customerref"=>"NONREF",
         "datum"=>"2014-04-17",
         "empfaenger_blz"=>"ENTENXXXXXX",
         "empfaenger_konto"=>"DE12345678901234567890",
         "empfaenger_name"=>"DAGOBERT DUCK",
         "gvcode"=>"020",
         "id"=>"138",
         "konto_id"=>"2",
         "primanota"=>"006200",
         "saldo"=>"1111.12",
         "valuta"=>"2014-04-17",
         "zweck2"=>"Danke",
         "zweck"=>"Miete Geldspeicher"
       }
      StatementLine.map_response_data(valid_api_response)
    end

    context "correct API data given" do
      let(:attrs) { valid_attrs }
      it "is valid" do
        validator = StatementLine::Validator.new(attrs)
        validator.should be_valid, validator.errors.messages
      end
    end

    context "BIC with 9 characters given (invalid)" do
      let(:attrs) { r = valid_attrs.dup; r[:bic] = "ABCABCABC"; r }
      it "is invalid" do
        pending "validations still need to be implemented."
        
        validator = StatementLine::Validator.new(attrs)
        validator.should_not be_valid
        validator.errors.messages.should == {:bic=>["BIC must be 8 or 11 characters in the range A-Z"]}
      end
    end

  end
end