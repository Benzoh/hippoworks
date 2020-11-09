module GroupModule
  extend ActiveSupport::Concern

  # TODO: 現在参加しているグループのメンバーID
  def get_joined_accounts(group_id)
    GroupAccount.where(group_id: group_id)
  end

end