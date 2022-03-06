class AddColumnToProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :group_id, :integer
  end
end
