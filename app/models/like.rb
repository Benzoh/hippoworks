class Like < ApplicationRecord
  validates :user_id, { presence: true }
  validates :thread_type, { presence: true }
  validates :thread_id, { presence: true }
end
