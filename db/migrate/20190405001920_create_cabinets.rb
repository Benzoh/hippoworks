class CreateCabinets < ActiveRecord::Migration[5.2]
  def change
    create_table :cabinets do |t|
      t.string :title
      t.text :memo
      t.integer :folder_id
      t.integer :current_version
      t.integer :update_user_id
      t.string :file_name
      t.timestamps
    end
  end
end
