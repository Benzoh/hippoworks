class Board < ApplicationRecord
  belongs_to :group

  def user_name
    User.find_by(id: self.user_id).name
  end

  def last_update_user_name
    "TODO: 最終更新者の名前"
  end
end
