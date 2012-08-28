module Filters
  def self.included(base)
    base.extend ClassMethods
  end
  
  module ClassMethods
    def before_filter(method)
      unless instance_variable_defined? :@before_filters
        instance_variable_set :@before_filters, []
      end
      instance_variable_get(:@before_filters) << method
    end
    def after_filter(method)
      unless instance_variable_defined? :@after_filters
        instance_variable_set :@after_filters, []
      end
      instance_variable_get(:@after_filters) << method
    end
    def around_filter(method)
      unless instance_variable_defined? :@around_filters
        instance_variable_set :@around_filters, []
      end
      instance_variable_get(:@around_filters) << method
    end
  end
  
  def filter
    before_filters = self.class.instance_variable_get(:@before_filters) ||[]
    after_filters = self.class.instance_variable_get(:@after_filters) ||[]
    around_filters = self.class.instance_variable_get(:@around_filters) ||[]
    process_proc = proc do
      before_filters.each { |method| send(method) }
      yield
      after_filters.each { |method| send(method) }
    end
    
    around_filters.reverse.each do |method|
      previous_proc = process_proc
      process_proc = proc { send(method, &previous_proc) }
    end
    
    process_proc.call
  end
end
