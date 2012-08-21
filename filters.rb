require "active_support/all"

module Filters
  # extend ActiveSupport::Concern
  # 
  # included do
  #   self.class_attribute :before_filters
  #   self.before_filters = []
  #   self.class_attribute :after_filters
  #   self.after_filters = []
  #   self.class_attribute :around_filters
  #   self.around_filters = []
  # end
  # 
  # module ClassMethods
  #   def before_filter(method)
  #     self.before_filters += [method]
  #   end
  #   def after_filter(method)
  #     self.after_filters += [method]
  #   end
  #   def around_filter(method)
  #     self.around_filters += [method]
  #   end
  # end
  # 
  # def filter
  #   process_proc = proc do
  #     before_filters.each { |method| send(method) }
  #     yield
  #     after_filters.each { |method| send(method) }
  #   end
  #   
  #   around_filters.reverse.each do |method|
  #     proc = process_proc
  #     process_proc = proc { send(method, &proc) }
  #   end
  #   
  #   process_proc.call
  # end
  
  
  ###### Using ActiveSupport::Callbacks ######
  extend ActiveSupport::Concern
  
  included do
    include ActiveSupport::Callbacks
    define_callbacks :process
  end
  
  module ClassMethods
    def before_filter(method)
      set_callback :process, :before, method
    end
    def after_filter(method)
      set_callback :process, :after, method
    end
    def around_filter(method)
      set_callback :process, :around, method
    end
  end
  
  def filter
    run_callbacks :process do
      yield
    end
  end
end