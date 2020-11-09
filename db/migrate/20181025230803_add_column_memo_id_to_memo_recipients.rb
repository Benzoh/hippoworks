class AddColumnMemoIdToMemoRecipients < ActiveRecord::Migration[5.2]
  def change
    add_column :memo_recipients, :memo_id, :integer
  end
end
