class RenameMemoRecipientToMemoRecipients < ActiveRecord::Migration[5.2]
  def change
    rename_table :memo_recipient, :memo_recipients
  end
end
