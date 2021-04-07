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

    def copy
      base = self.class.new
      mailing_lists.each_pair do |key, val|
        base.mailing_lists[key] = val.copy
      end
      base
    end
  end
end
