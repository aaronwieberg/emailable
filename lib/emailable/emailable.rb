module Emailable
  def self.included(base)
    base.extend ClassMethods
    super
  end

  module ClassMethods
    def inherited(klass)
      super
      klass.instance_variable_set(:@mailing_lists, mailing_lists.copy)
    end

    def emailable(&block)
      @mailing_lists ||= Emailable::Base.new
      @mailing_lists.instance_eval(&block)
      @mailing_lists
    end

    def mailing_lists
      @mailing_lists
    end
  end

  def mailing_list(name = :default)
    self.class.mailing_lists[name].process(self)
  end
end
