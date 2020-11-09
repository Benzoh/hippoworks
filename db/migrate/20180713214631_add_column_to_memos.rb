class AddColumnToMemos < ActiveRecord::Migration[5.2]
  def change
    add_column :memos, :account_id, :integer
  end
end
