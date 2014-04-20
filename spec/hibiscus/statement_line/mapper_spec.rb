require 'spec_helper'
require 'hibiscus/statement_line'
require 'hibiscus/statement_line/mapper'

module Hibiscus
  describe StatementLine::Mapper do

    describe "#perform" do

      let(:valid_api_response) do
        {"art"=>"\xDCberweisung",
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
      end

      it "maps api data correctly" do
        mapper = StatementLine::Mapper.new.perform(valid_api_response)
        mapper[:type].should == "\xDCberweisung"
        mapper[:amount].should == Money.new("-15690", 'EUR')
        mapper[:checksum].should == "835255347"
        mapper[:customerref].should == "NONREF"
        mapper[:date].should == Date.new(2014, 4, 17)
        mapper[:recipient_bic].should == "ENTENXXXXXX"
        mapper[:recipient_name].should == "DAGOBERT DUCK"
        mapper[:recipient_account].should == "DE12345678901234567890"
        mapper[:gvcode].should == "020"
        mapper[:id].should == 138
        mapper[:account_id].should == 2
        mapper[:primanota].should == "006200"
        mapper[:balance].should == Money.new("111112", 'EUR')
        mapper[:valuta].should == Date.new(2014, 4, 17)
        mapper[:reference].should == "Miete Geldspeicher\nDanke"
      end
    end
  end
end