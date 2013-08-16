module Emailable
  def self.included(base)
    base.extend ClassMethods
    super
  end


  module ClassMethods
    def emailable(&block)
      @mailing_lists ||= Emailable::Base.new.tap{ |m| m.instance_eval(&block) }
    end


    def mailing_lists
      @mailing_lists
    end
  end


  def mailing_list(name = :default)
    @mailing_lists ||= {}
    @mailing_lists[name] ||= self.class.mailing_lists[name].process(self)
  end
end