class ShareFile < ApplicationRecord
  belongs_to :cabinet
  has_many_attached :files

  def last_update_user_name
    User.find_by(id: self.update_user_id).name
  end
end
