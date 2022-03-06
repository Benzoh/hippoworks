class ChangeColumnToProject < ActiveRecord::Migration[5.2]
  def change
    change_column :projects, :number, :integer, null: false, default: 0
    add_column :projects, :charge_member_id, :integer
    add_column :projects, :priority, :string
    add_column :projects, :status_id, :integer
    add_column :projects, :category_id, :integer
  end
end
