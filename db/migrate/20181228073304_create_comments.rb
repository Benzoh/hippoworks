class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.integer :comment_index_id
      t.string :title
      t.text :body
      t.integer :user_id
      t.integer :parent_id
      t.string :parent_type

      t.timestamps
    end
  end
end
