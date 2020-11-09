class AddColumnToTimer < ActiveRecord::Migration[5.2]
  def change
    add_column :timers, :h, :integer
    add_column :timers, :m, :integer
    add_column :timers, :s, :integer
  end
end
