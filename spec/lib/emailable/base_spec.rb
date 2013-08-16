require 'spec_helper'

describe Emailable::Base do
  let (:base) { Emailable::Base.new }

  it "responds to mailing_lists" do
    base.should respond_to(:mailing_lists)
  end


  describe "mailing_list" do
    it "will raise an exception if no block is given" do
      expect { base.mailing_list :test }.to raise_error(Emailable::EmptyMailingList)
    end

    it "will create a new mailing list" do
      expect { base.mailing_list{} }.to change { base.mailing_lists.count }.from(0).to(1)
    end

    it "will create a default mailing list when a block is given" do
      base.mailing_list{}
      base.mailing_lists[:default].should be_an_instance_of(Emailable::MailingList)
    end

    it "will create a named mailing list" do
      base.mailing_list(:people) {}
      base.mailing_lists[:people].should_not be_nil
    end

    it "will create a named mailing list when a string is given as name" do
      expect { base.mailing_list("group1"){} }.to change { base.mailing_lists.count }.from(0).to(1)
      base.mailing_lists[:group1].should_not be_nil
    end
  end


  describe "[]" do
    before do
      base.mailing_list(:people){}
    end

    it "will return the mailing list for the given name" do
      base[:people].should be_an_instance_of(Emailable::MailingList)
    end

    it "will return the mailing list for the given string name" do
      base["people"].should be_an_instance_of(Emailable::MailingList)
    end

    it "will raise an exception if the mailing list by the name does not exist" do
      expect { base[:bad] }.to raise_error(Emailable::UndefinedMailingList)
    end
  end
end
