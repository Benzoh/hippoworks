class CreateInvites < ActiveRecord::Migration[5.2]
  def change
    create_table :invites do |t|
      t.string :mail_to
      t.integer :account_id
      t.string :state

      t.timestamps
    end
  end
end
