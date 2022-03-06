class AddColumnToBoard < ActiveRecord::Migration[5.2]
  def change
    add_column :boards, :current_comment_index_id, :integer
  end
end
