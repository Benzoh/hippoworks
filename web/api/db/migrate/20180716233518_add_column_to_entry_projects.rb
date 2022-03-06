class AddColumnToEntryProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :entry_projects, :account_id, :integer
    remove_column :entry_projects, :user_id, :integer
  end
end
