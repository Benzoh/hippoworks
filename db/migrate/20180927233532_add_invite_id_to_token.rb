class AddInviteIdToToken < ActiveRecord::Migration[5.2]
  def change
    add_column :tokens, :invite_id, :integer
  end
end
