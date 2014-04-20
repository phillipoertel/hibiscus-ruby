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
      it "caches the validator instance" do
        DummyResource::Validator.should_receive(:new).once.and_call_original
        2.times { resource.validator }
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


  end
end