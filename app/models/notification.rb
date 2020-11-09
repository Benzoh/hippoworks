class Notification < ApplicationRecord

  def self.set_notifications(thread_type, thread_id, user_id)
    return if user_id.blank?

    if thread_type == 'comment'
      comment = Comment.find_by(id: thread_id)
    else
      comment = ''
    end

    if user_id.class == Array
      # TODO: リファクタリング
      user_id.each do |id|
        notification = self.new(
          thread_type: thread_type,
          thread_id: thread_id,
          user_id: id,
          parent_type: comment.present? ? comment.parent_type : thread_type,
          parent_id: comment.present? ? comment.parent_id : thread_id,
        )
        existing = self.find_by(
          thread_type: thread_type,
          thread_id: thread_id,
          user_id: id,
          parent_type: comment.present? ? comment.parent_type : thread_type,
          parent_id: comment.present? ? comment.parent_id : thread_id,
        )
        notification.save if existing.blank?
      end
    else
      notification = self.new(
        thread_type: thread_type,
        thread_id: thread_id,
        user_id: user_id,
        parent_type: comment.present? ? comment.parent_type : thread_type,
        parent_id: comment.present? ? comment.parent_id : thread_id,
      )
      existing = self.find_by(
        thread_type: thread_type,
        thread_id: thread_id,
        user_id: user_id,
        parent_type: comment.present? ? comment.parent_type : thread_type,
        parent_id: comment.present? ? comment.parent_id : thread_id,
      )
      notification.save if existing.blank?
    end
    return true
  end

end
