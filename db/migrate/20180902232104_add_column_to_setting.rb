class AddColumnToSetting < ActiveRecord::Migration[5.2]
  def change
    add_column :settings, :account_id, :integer
  end
end
