class CreateGroupAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :group_accounts do |t|
      t.references :account, foreign_key: true
      t.references :group, foreign_key: true

      t.timestamps
    end
  end
end
