class ChangeColumnToTimer < ActiveRecord::Migration[5.2]
  def change
    change_column :timers, :h, :integer, default: 0
    change_column :timers, :m, :integer, default: 0
    change_column :timers, :s, :integer, default: 0
    change_column :timers, :secs, :integer, default: 600
  end
end
