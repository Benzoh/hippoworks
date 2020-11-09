class MemoRecipient < ApplicationRecord
  belongs_to :memo

  scope :not_read, -> { where(is_read: false) }
end
