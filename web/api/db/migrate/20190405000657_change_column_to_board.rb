class ChangeColumnToBoard < ActiveRecord::Migration[5.2]
  def change
    change_column :boards, :current_comment_index_id, :integer, default: 1
  end
end
