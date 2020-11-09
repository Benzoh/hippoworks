class AddColumnToNotification < ActiveRecord::Migration[5.2]
  def change
    add_column :notifications, :parent_type, :string
    add_column :notifications, :parent_id, :bigint
  end
end
