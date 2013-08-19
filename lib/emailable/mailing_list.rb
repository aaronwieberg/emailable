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
      self.list.merge!({ method_sym => get_record_value_for(args.first) })
    end


    private


    def get_record_value_for(attrib)
      case attrib
        when Array then attrib.collect{ |item| get_record_value_for(item) }.flatten.compact
        when Proc then attrib.call(record)
        when String then attrib
        when Symbol then record.send(attrib)
        else nil
      end
    end
  end
end
