require 'spec_helper'

describe Emailable do
  let (:project) { Project.new }


  describe "default mailing list" do
    it "will have a default mailing list if a mailing list is defined without a name specified" do
      project.mailing_list.to.should eq "to@example.org"
    end

    it "will return the default mailing list by name" do
      project.mailing_list(:default).to.should eq "to@example.org"
    end
  end


  describe "when using a non-default name" do
    it "will allow retrieval of a mailing list by name" do
      project.mailing_list(:admins).to.should be_nil
      project.mailing_list(:admins).bcc.should eq ["a1@example.org", "a2@example.org"]
    end

    it "will allow retrieval when using a string as name" do
      project.mailing_list("admins").bcc.should_not be_nil
    end
  end


  it "returns all mailing list recipients as an OpenStruct" do
    project.mailing_list(:admins).should be_an_instance_of(OpenStruct)
  end
end