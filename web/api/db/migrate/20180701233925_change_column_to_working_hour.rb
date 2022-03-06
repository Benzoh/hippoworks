class ChangeColumnToWorkingHour < ActiveRecord::Migration[5.2]
  def change
    change_column :working_hours, :secs, :integer, null: false, default: 0
  end
end
