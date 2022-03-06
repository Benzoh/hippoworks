class AddColumnToInvite < ActiveRecord::Migration[5.2]
  def change
    add_column :invites, :group_id, :integer
  end
end
