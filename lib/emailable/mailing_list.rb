module Emailable
  class MailingList
    attr_reader :definition

    def initialize(definition)
      @definition = definition
    end

    def process(record)
      MailingListProcessor.new(definition, record).process!
    end

    def copy
      self.class.new(definition.dup)
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
      instance_exec record, &definition
      list
    end

    def method_missing(method_sym, *args)
      list.merge!({ method_sym => get_record_value_for(args.first) })
    end

    def respond_to_missing?(_method_sym)
      true
    end

    private

    def get_record_value_for(attrib)
      case attrib
      when Array then attrib.collect { |item| get_record_value_for(item) }.flatten.compact
      when Proc then attrib.call(record)
      when String then attrib
      when Symbol then record.send(attrib)
      end
    end
  end
end
