class CreateCalendarAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :calendar_accounts do |t|
      t.integer :calendar_id
      t.integer :account_id
      t.timestamps
    end
  end
end
