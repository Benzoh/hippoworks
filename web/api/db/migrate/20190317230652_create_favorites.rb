class CreateFavorites < ActiveRecord::Migration[5.2]
  def change
    create_table :favorites do |t|
      t.integer :account_id
      t.integer :record_id
      t.string :record_type
      t.integer :parent_id
      t.string :parent_type

      t.timestamps
    end
  end
end
