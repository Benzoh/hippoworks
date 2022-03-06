class AddColumnDescriptionToProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :description, :text, limit: 16777215
  end
end
