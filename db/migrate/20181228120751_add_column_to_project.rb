class AddColumnToProject < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :current_comment_index_id, :integer, default: 1
  end
end
