class Cabinet < ApplicationRecord
  belongs_to :group
  has_one :share_file
  accepts_nested_attributes_for :share_file

  def user_name
    User.find_by(id: self.user_id).name
  end
end
