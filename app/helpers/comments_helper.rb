module CommentsHelper
  def get_comment_form(parent_model, comment_model, notification_ids)
    render :partial => 'shared/comments', locals: { parent: parent_model, comments: comment_model, notification_ids: notification_ids }
  end
end
