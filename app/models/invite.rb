class Invite < ApplicationRecord
  has_one :token, dependent: :destroy
end
