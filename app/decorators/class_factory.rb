class ClassFactory

  def self.create_class(new_class, table, connection_name)
    # Object.const_set(new_class, Class.new(ActiveRecord::Base) {})
    # new_class.constantize.table_name = table
    # new_class.constantize.establish_connection(connection_name)
  end

end