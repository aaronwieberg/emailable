require 'spec_helper'

describe Emailable do
  let (:project) { Project.new }


  describe "default mailing list" do
    it "will have a default mailing list if a mailing list is defined without a name specified" do
      project.mailing_list.should be_an_instance_of(Hash)
    end

    it "will return the default mailing list by name" do
      project.mailing_list(:default).should be_an_instance_of(Hash)
    end

    it "will have to, cc, and bcc keys and values" do
      project.mailing_list.should eq({
        to: "to@example.org",
        cc:  "cc@example.org",
        bcc: "bcc@example.org"
      })
    end
  end


  describe "when using a non-default name" do
    it "will allow retrieval of a mailing list by name" do
      project.mailing_list(:admins)[:bcc].should eq ["a1@example.org", "a2@example.org"]
    end

    it "will allow retrieval when using a string as name" do
      project.mailing_list("admins")[:bcc].should_not be_nil
    end
  end


  it "returns all mailing list recipients as a Hash" do
    project.mailing_list(:admins).should be_an_instance_of(Hash)
  end


  describe "an subclass inherits the parent's mailing lists" do
    before do
      class Subproject < Project; end;
    end

    it "has each of the parent's mailing lists" do
      Subproject.new.mailing_list(:default).should be_an_instance_of(Hash)
      Subproject.new.mailing_list(:admins).should be_an_instance_of(Hash)
    end
  end
end
