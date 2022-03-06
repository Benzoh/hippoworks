class CommentRecipient < ApplicationRecord
  belongs_to :comment

  scope :not_read, -> { where(is_read: false) }
end
