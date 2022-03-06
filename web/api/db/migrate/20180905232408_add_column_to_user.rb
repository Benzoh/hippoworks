class AddColumnToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :company, :string
    add_column :users, :birthday, :date
    add_column :users, :address, :string
    add_column :users, :url, :string
    add_column :users, :introduction, :string
    remove_column :users, :password, :string
    remove_column :users, :email, :string
  end
end
