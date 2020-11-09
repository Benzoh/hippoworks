class CreateCalendars < ActiveRecord::Migration[5.2]
  def change
    create_table :calendars do |t|
      t.integer :group_id, null: false
      t.integer :account_id, null: false
      t.string :category
      t.string :name, null: false
      t.text :description, limit: 16777215
      t.integer :start_year, null: false
      t.integer :start_month, null: false
      t.integer :start_day, null: false
      t.integer :start_hour
      t.integer :start_minute
      t.string :mode, null: false, default: 'normal'
      t.string :repeat_condition_type
      t.string :repeat_condition_day_of_week
      t.boolean :period_unlimited
      t.timestamps
    end
  end
end
