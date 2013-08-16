module Emailable
  class MailingList
    attr_reader :definition
  

    def initialize(definition)
      @definition = definition
    end


    def process(record)
      MailingListProcessor.new(definition, record).process!
    end
  end


  class MailingListProcessor
    attr_reader :definition, :list, :record


    def initialize(definition, record)
      @definition = definition
      @record = record

      @list = {}
    end


    def process!
      instance_exec self.record, &self.definition
      self.list
    end


    def method_missing(method_sym, *args)
      addresses = case args.first
        when Proc then args.first.call(record)
        when String then args.first
        when Symbol then record.send(args.first)
        else nil
      end

      self.list.merge!({ method_sym => addresses })
    end
  end
end
