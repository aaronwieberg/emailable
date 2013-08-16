describe Emailable::EmptyMailingList do
  let (:empty) do
    class TestEmptyMailingList
      include Emailable

      emailable do
        mailing_list :empty
      end
    end
  end

  it "will be raised when a class is defined with a mailing_list call without a block supplied" do
    expect { empty }.to raise_error(Emailable::EmptyMailingList)
  end
end


describe Emailable::UndefinedMailingList do
  let (:project) { Project.new } 

  it "should be raised when requesting the members of a mailing list that has not been defined" do
    expect { project.mailing_list(:bad) }.to raise_error(Emailable::UndefinedMailingList)
  end
end
