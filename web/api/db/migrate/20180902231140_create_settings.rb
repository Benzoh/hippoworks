class CreateSettings < ActiveRecord::Migration[5.2]
  def change
    create_table :settings do |t|
      t.string :language
      t.integer :post_per
      t.string :week_start
      t.boolean :push_mail
      t.integer :push_interval

      t.timestamps
    end
  end
end
