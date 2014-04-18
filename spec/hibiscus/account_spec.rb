require 'spec_helper'
require 'hibiscus/resource'
require 'hibiscus/account'

module Hibiscus
  describe Account do
    
    let(:account) { Hibiscus::Account.new({}) }

    def stub_client_response(response)
      client_double = double('Client')
      client_double.stub(:get) { response }
      account.stub(:client).and_return(client_double)
    end

    describe "#all" do
      it "requests correct URL on client" do
        client_double = double('Client')
        client_double.should_receive(:get).with('/konto/list').and_return([])
        account.stub(:client).and_return(client_double)
        account.all
      end

      it "returns account objects" do
        response = [{"bezeichnung"=>"Magic-Konto", 
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
        stub_client_response(response)
        first = account.all.first
        first.should be_instance_of Hibiscus::Account
        first.id.should == 1
        first.bic.should == "MYBANKXXXXX"
        first.iban.should == "AA12345678901234567890"
        first.label.should == "Magic-Konto"
        first.customer_number.should == "47114711"
        first.holder_name.should == "MUSTERMANN, MAX"
        first.balance.cents.should == -10001
        first.balance.currency.should == "EUR"
        first.balance_date.to_s.should == "2014-04-17 09:10:50 +0200"
        first.should be_valid
      end
    end

  end
end