require 'ostruct'

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

      @list = OpenStruct.new      
    end


    def process!
      instance_exec self.record, &self.definition
      self.list
    end


    [:to, :cc, :bcc].each do |method_sym|
      class_eval <<-EVAL

        def #{method_sym}(recipients)
          addresses = case recipients
            when Symbol then record.send(recipients)
            when Proc then recipients.call(record)
            else nil
          end

          self.list.send("#{method_sym}=", addresses)
        end

      EVAL
    end
  end
end
