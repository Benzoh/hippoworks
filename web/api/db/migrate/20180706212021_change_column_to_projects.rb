class ChangeColumnToProjects < ActiveRecord::Migration[5.2]
  def change
    rename_column :projects, :charge_member_id, :charge_user_id
  end
end
