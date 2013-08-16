module Emailable
  class Base
    attr_reader :mailing_lists

    def initialize
      @mailing_lists = {}
    end


    def mailing_list(name = :default, &definition)
      raise(Emailable::EmptyMailingList) unless block_given?

      mailing_lists[name.intern] = Emailable::MailingList.new definition
    end


    def [](name)
      raise Emailable::UndefinedMailingList if mailing_lists[name.intern].nil?

      mailing_lists[name.intern]
    end  
  end
end
