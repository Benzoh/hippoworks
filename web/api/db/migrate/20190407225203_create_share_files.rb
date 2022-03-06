class CreateShareFiles < ActiveRecord::Migration[5.2]
  def change
    create_table :share_files do |t|
      t.integer :version
      t.integer :update_user_id
      t.string :filename
      t.text :memo
      t.integer :cabinet_id

      t.timestamps
    end
  end
end
