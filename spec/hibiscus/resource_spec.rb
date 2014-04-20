require 'spec_helper'
require 'hibiscus/resource'
require 'hibiscus/account'

module Hibiscus
  describe Resource do
    
    class DummyResource < Resource
      class Validator
        include ActiveModel::Validations
        def initialize(attrs = {})
          @attrs = attrs
        end
      end
      class Mapper
      end
    end

    let(:resource) { DummyResource.new }

    describe "dynamic attribute readers" do
      it "has methods for each attribute" do
        resource = Resource.new(foo: "bar")
        resource.foo.should == "bar"
      end
      it "works when attribute keys are strings" do
        resource = Resource.new("foo" => "bar")
        resource.foo.should == "bar"
      end
      it "raises NoMethodError for unknown attributes" do
        resource = Resource.new(foo: "bar")
        expect { resource.baz }.to raise_error(NoMethodError, /baz/)
      end
    end

    describe "#valid?" do
      it "uses the corresponding Validator class" do
        resource.stub(:client)
        DummyResource::Validator.should_receive(:new).with(resource.attrs).and_call_original
        DummyResource::Validator.any_instance.should_receive(:valid?)
        resource.valid?
      end
    end

    describe "#validator" do
      it "caches the instance" do
        DummyResource::Validator.should_receive(:new).once.and_call_original
        2.times { resource.validator }
      end
      it "returns an instance" do
        resource.validator.should be_instance_of DummyResource::Validator
      end
    end

    describe "#mapper" do
      it "caches the instance" do
        DummyResource::Mapper.should_receive(:new).once.and_call_original
        2.times { resource.mapper }
      end
      it "returns an instance" do
        resource.mapper.should be_instance_of DummyResource::Mapper
      end
    end

    describe "#errors" do
      it "is empty when not validated" do
        resource.errors.should be_empty
      end
      it "is set when validated" do
        DummyResource::Validator.any_instance.stub(:valid?)
        DummyResource::Validator.any_instance.should_receive(:errors).and_return(["something"])
        resource.valid?
        resource.errors.should_not be_empty
      end
    end

    describe ".new_from_response" do

      it "returns an object of correct type" do
        pending "valid_api_response missing"
        resource = DummyResource.new_from_response(valid_api_response)
        resource.should be_instance_of Hibiscus::DummyResource
      end

      it "raises an error when API data is invalid" do
        pending "valid_api_response missing"
        invalid = valid_api_response.dup
        invalid.delete("id")
        expect { Account.new_from_response(invalid) }.to raise_error(Account::InvalidResponseData, '{:id=>["is not included in the list"]}')
      end
    end

  end
end