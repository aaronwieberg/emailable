require 'spec_helper'

describe Emailable::MailingList do
  it "initializes the mailing list definition" do
    Emailable::MailingList.new(:the_definition).definition.should eq :the_definition
  end


  describe "process!" do
    it "creates a MailingListProcessor which processes the list for the given record" do
      processor = double("processor")
      processor.should_receive(:process!).and_return(:a_result)

      Emailable::MailingListProcessor.should_receive(:new).with(:a_definition, :a_record).and_return(processor)

      Emailable::MailingList.new(:a_definition).process(:a_record).should eq :a_result
    end
  end
end


describe Emailable::MailingListProcessor do
  let (:definition) {
    Proc.new do
      to :email
      cc ->(record) { record.sender }
      bcc [:boss, :assistant, :others]
      from "test@example.org"
    end
  }

  let (:record) { double("Record", email: "email@example.org", 
    sender: "sender@example.org", boss: "boss@example.org", assistant: "assistant@example.org", 
    others: ["a@example.org", "b@example.org"]) }

  let (:processor) { Emailable::MailingListProcessor.new(definition, record)}
  

  describe "field types" do
    it "calls a method by name for symbol arguments" do
      processor.process![:to].should eq "email@example.org"
    end

    it "calls a proc providing the record as an argument to the proc" do
      processor.process![:cc].should eq "sender@example.org"
    end

    it "handles each item of an array with an array argment" do
      processor.process![:bcc].should eq ["boss@example.org", "assistant@example.org", "a@example.org", "b@example.org"]
    end

    it "will use a string as the value of the field" do
      processor.process![:from].should eq "test@example.org"
    end
  end
end

