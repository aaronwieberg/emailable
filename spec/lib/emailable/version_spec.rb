require 'spec_helper'

describe Emailable do
  it "must be defined" do
    Emailable::VERSION.should_not be_nil
  end
end
