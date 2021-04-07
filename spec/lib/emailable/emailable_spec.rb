require 'spec_helper'

describe Emailable do
  let(:project) { Project.new }

  describe 'default mailing list' do
    it 'will have a default mailing list if a mailing list is defined without a name specified' do
      expect(project.mailing_list).to be_an_instance_of(Hash)
    end

    it 'will return the default mailing list by name' do
      expect(project.mailing_list(:default)).to be_an_instance_of(Hash)
    end

    it 'will have to, cc, and bcc keys and values' do
      expect(project.mailing_list).to eq(
        to: 'to@example.org',
        cc: 'cc@example.org',
        bcc: 'bcc@example.org'
      )
    end
  end

  describe 'when using a non-default name' do
    it 'will allow retrieval of a mailing list by name' do
      expect(project.mailing_list(:admins)[:bcc]).to eq ['a1@example.org', 'a2@example.org']
    end

    it 'will allow retrieval when using a string as name' do
      expect(project.mailing_list('admins')[:bcc]).to_not be_nil
    end
  end

  it 'returns all mailing list recipients as a Hash' do
    expect(project.mailing_list(:admins)).to be_an_instance_of(Hash)
  end

  describe 'a subclass inherits the parents mailing lists' do
    before do
      class Subproject < Project; end
    end

    it 'has each of the parents mailing lists' do
      expect(Subproject.new.mailing_list(:default)).to be_an_instance_of(Hash)
      expect(Subproject.new.mailing_list(:admins)).to be_an_instance_of(Hash)
    end
  end

  describe 'a subclass can override the parents mailing lists' do
    let(:project) { SpecialProject.new }

    it 'will return the overridden mailing lists as defined' do
      expect(project.mailing_list(:default)).to eq(
        to: 'to@example.org',
        bcc: 'cc@example.org'
      )

      # Project mailing list is unchanged.
      expect(Project.new.mailing_list(:default)).to eq(
        to: 'to@example.org',
        cc: 'cc@example.org',
        bcc: 'bcc@example.org'
      )
    end

    it 'will return mailing lists defined in subclass' do
      expect(project.mailing_list(:special)).to eq(
        to: 'someone@special.example'
      )

      # Parent class is unaware of this mailing list
      expect { Project.new.mailing_list(:special) }.to raise_error(Emailable::UndefinedMailingList)
    end
  end
end
