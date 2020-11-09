class AddColumnToStandardOperation < ActiveRecord::Migration[5.2]
  def change
    add_column :standard_operations, :state, :integer
  end
end
