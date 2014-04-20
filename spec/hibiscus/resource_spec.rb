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

    describe ".mapper" do
      it "returns a mapper instance" do
        DummyResource.mapper.should be_instance_of DummyResource::Mapper
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
      it "maps the passed attributes" do
        mapper         = double("Mapper")
        response_attrs = double("API response attributes")
        mapper.should_receive(:perform).with(response_attrs).and_return({})
        DummyResource.stub(:mapper).and_return(mapper)
        DummyResource.new_from_response(response_attrs)
      end

      it "validates the mapped attributes" do
        DummyResource::Mapper.any_instance.stub(:perform).and_return({})
        resource = double("DummyResource")
        resource.should_receive(:valid?).and_return(true)
        DummyResource.stub(:new).and_return(resource)
        DummyResource.new_from_response({})
      end

      it "calls new on the correct resource and returns that instance" do
        DummyResource::Mapper.any_instance.stub(:perform).and_return({})
        resource = double("DummyResource", :valid? => true)
        DummyResource.should_receive(:new).and_return(resource)
        DummyResource.new_from_response({}).should == resource
      end

      it "raises an error when API data is invalid" do
        DummyResource::Mapper.any_instance.stub(:perform).and_return({})
        resource = double("DummyResource")
        resource.should_receive(:valid?).and_return(false)
        resource.stub_chain(:errors, :messages).and_return("Error messages")
        DummyResource.stub(:new).and_return(resource)
        expect { DummyResource.new_from_response({}) }.to raise_error(Hibiscus::Resource::InvalidResponseData, "Error messages")
      end
    end

  end
end