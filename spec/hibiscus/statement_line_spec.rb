require 'spec_helper'
require 'hibiscus/resource'
require 'hibiscus/statement_line'

module Hibiscus
  describe StatementLine do

    let(:line) { StatementLine.new }

    # describe "#valid?" do
    #   it "uses StatementLine::Validator" do
    #     line.stub(:client)
    #     StatementLine::Validator.should_receive(:new).with(line.attrs).and_call_original
    #     StatementLine::Validator.any_instance.should_receive(:valid?)
    #     line.valid?
    #   end
    # end

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

    describe ".new_from_response" do

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

      it "returns an StatementLine object" do
        object = StatementLine.new_from_response(valid_api_response)
        object.should be_instance_of Hibiscus::StatementLine
      end

      it "maps api data correctly" do
        object = StatementLine.new_from_response(valid_api_response)
        object.type.should == "\xDCberweisung"
        object.amount.should == Money.new("-15690", 'EUR')
        object.checksum.should == "835255347"
        object.customerref.should == "NONREF"
        object.date.should == Date.new(2014, 4, 17)
        object.recipient_bic.should == "ENTENXXXXXX"
        object.recipient_name.should == "DAGOBERT DUCK"
        object.recipient_account.should == "DE12345678901234567890"
        object.gvcode.should == "020"
        object.id.should == 138
        object.account_id.should == 2
        object.primanota.should == "006200"
        object.balance.should == Money.new("111112", 'EUR')
        object.valuta.should == Date.new(2014, 4, 17)
        object.reference.should == "Miete Geldspeicher\nDanke"
      end

      it "raises an error when api data is invalid" do
        pending "validations still need to be implemented."
        invalid = valid_api_response.dup
        invalid.delete("id")
        expect { StatementLine.new_from_response(invalid) }.to raise_error(StatementLine::InvalidResponseData, '{:id=>["is not included in the list"]}')
      end


    end
  end
end