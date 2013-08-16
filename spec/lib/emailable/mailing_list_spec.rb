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
