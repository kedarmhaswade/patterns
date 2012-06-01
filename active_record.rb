require "connection_adapter"

module ActiveRecord
  class Base
    @@connection = SqliteAdapter.new

    def initialize(attributes)
      @attributes = attributes
    end

    def method_missing(name, *args)
      if self.class.columns.include?(name)
        @attributes[name]
      else
        super
      end
    end

    def self.find(id)
      find_by_sql("SELECT * FROM #{table_name} WHERE id = #{id.to_i} LIMIT 1").first
    end

    def self.all
      find_by_sql("SELECT * FROM #{table_name}")
    end

    def self.find_by_sql(sql)
      rows = @@connection.execute(sql)
      rows.map do |row|
        attributes = map_values_to_columns(row)
        new(attributes)
      end
    end

    def self.map_values_to_columns(values)
      Hash[columns.zip(values)]
    end

    def self.columns
      @@connection.columns(table_name)
    end
    
    def self.table_name
      name.downcase + "s" # => "users"
    end
    
    def self.scoped
      Relation.new(self)
    end
    
    def self.where(condition)
      scoped.where(condition)
    end
  end
  
  class Relation
    attr_accessor :conditions
    
    def initialize(klass)
      @klass = klass
      @conditions = []
    end
    
    def where(condition)
      relation = clone
      relation.conditions += [condition]
      relation
    end
    
    def to_sql
      sql = "SELECT * FROM #{@klass.table_name}"
      sql << " WHERE " + @conditions.join(" AND ") if @conditions.any?
      sql
    end
    
    def method_missing(name, *args, &block)
      if Array.method_defined?(name)
        results = @klass.find_by_sql(to_sql)
        results.send(name, *args, &block)
      else
        super
      end
    end
  end
end