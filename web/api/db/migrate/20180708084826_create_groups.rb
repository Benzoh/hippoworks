class CreateGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :groups do |t|
      t.string :name
      t.integer :create_account_id
      t.string :notice
      t.string :invitation_authority
      t.string :icon_img

      t.timestamps
    end
  end
end
