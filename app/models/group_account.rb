class GroupAccount < ApplicationRecord
  belongs_to :account
  belongs_to :group

  def user_name
    ga = GroupAccount.find_by(id: self.id)
    User.find_by(account_id: ga.account_id).name
  end
end
