require 'spec_helper'
require 'hibiscus/resource'
require 'hibiscus/account'
require 'hibiscus/account/mapper'

module Hibiscus
  describe Account::Mapper do

    describe "#perform" do

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

      it "maps API data correctly" do
        mapper = Account::Mapper.new.perform(valid_api_response)
        mapper[:id].should == 1
        mapper[:bic].should == "MYBANKXXXXX"
        mapper[:iban].should == "AA12345678901234567890"
        mapper[:label].should == "Magic-Konto"
        mapper[:customer_number].should == "47114711"
        mapper[:holder_name].should == "MUSTERMANN, MAX"
        mapper[:balance].cents.should == -10001
        mapper[:balance].currency.should == "EUR"
        mapper[:balance_date].should == Time.parse("2014-04-17 09:10:50.0")
      end
    end
  end
end