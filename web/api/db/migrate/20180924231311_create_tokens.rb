class CreateTokens < ActiveRecord::Migration[5.2]
  def change
    create_table :tokens do |t|
      t.string :uuid
      t.datetime :expired_at

      t.timestamps
    end
  end
end
