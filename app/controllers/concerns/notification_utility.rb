# frozen_string_literal: true

require 'active_support/concern'

# 通知まわり
module NotificationUtility
  extend ActiveSupport::Concern

  included do
    # ここにcallback等
    # scope :disabled, -> { where(disabled: true) }
  end

  # Notification取得
  def get_notifications(parent_thread_type, account_id)
    user = User.find_by(account_id: account_id)
    project_notification = Notification.where(
      thread_type: parent_thread_type, thread_id: params[:id], user_id: user.id)
    comment_notification = Notification.where(
      thread_type: 'comment', parent_id: params[:id], user_id: user.id)
    project_notification.or(comment_notification)
  end

  # TODO: リファクタリング
  def save_notifications(thread_type, model)
    if thread_type == 'calendar' && model.group_ids.count.positive?
      model.group_ids.each do |group_id|
        save(thread_type, model, group_id)
      end
    elsif thread_type == 'comment' && model.parent_type == 'calendar'
      parent = Calendar.find_by(id: model.parent_id)

      logger.debug("parent.group_ids ========================================")
      logger.debug(parent.group_ids)

      parent.group_ids.each do |group_id|
        logger.debug(group_id)
        save(thread_type, model, group_id)
      end
    elsif thread_type == 'comment' && model.parent_type == 'project'
      parent = Project.find_by(id: model.parent_id)
      save(thread_type, model, parent.group_id)
    else
      save(thread_type, model, params[:group_id])
    end
    # TODO: ここの処理微妙かも。
    true
  end

  def save_like_notifications(model)
    pushed_user_id = User.find_by(id: model.user_id).id
    target_user_id = Object.const_get(
      model.thread_type.classify).find_by(id: model.thread_id).user_id

    parent_type = model.thread_type
    parent_id = model.thread_id

    if model[:thread_type] == 'comment'
      comment = Comment.find_by(id: model.thread_id)
      parent_type = comment.parent_type
      parent_id = comment.parent_id
    end

    existing = LikeNotification.find_by(
      parent_type: parent_type,
      parent_id: parent_id,
      thread_type: model.thread_type,
      thread_id: model.thread_id,
      user_id: target_user_id,
      is_read: false,
      from_user_id: pushed_user_id,
    )
    return true if existing.present?

    if existing.blank?
      notification = LikeNotification.new(
        parent_type: parent_type,
        parent_id: parent_id,
        thread_type: model.thread_type,
        thread_id: model.thread_id,
        user_id: target_user_id,
        is_read: false,
        from_user_id: pushed_user_id,
      )
      return true if notification.save
    end
  end

  private

  def save(thread_type, model, group_id)
    return if group_id.blank?

    @group = Group.find_by id: group_id
    @group_members = @group.group_accounts.map do |ga|
      User.find_by(account_id: ga.account_id)
    end
    user = User.find_by(account_id: @current_account.id)
    gm = @group_members.pluck(:id)
    # TODO: 単独のときの処理が必要？？
    gm.delete(user.id)

    Notification.set_notifications(thread_type, model.id, gm)
  end
end
