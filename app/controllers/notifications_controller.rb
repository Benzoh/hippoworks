class NotificationsController < ApplicationController

  # GET /notifications
  # GET /notifications.json
  def index
    user = User.find_by(account_id: @current_account.id)
    @notifications = Notification.where(user_id: user.id)
    logger.debug("@notifications -----------------------")
    logger.debug(@notifications)

    render json: @notifications if @notifications
    # TODO: fetchと同じようにグループ化。
  end

  # DELETE /notifications/1
  # DELETE /notifications/1.json
  def destroy
    logger.debug("-----------------------")
    logger.debug(params)
    if params[:mark_as_read]
      user = User.find_by(account_id: @current_account.id)
      notifications = Notification.where(user_id: user.id, parent_type: params[:parent_type], parent_id: params[:parent_id])
      logger.debug("-----------------------")
      logger.debug(notifications.inspect)
      # raise
      notifications.each do |notification|
        notification.destroy
      end
    end
    render "notifications/mark_as_read", locals: {notification_id: params[:id]}
  end

  def fetch
    if @current_account
      @notifications = Notification.where(user_id: User.find_by(account_id: @current_account.id).id)
    end
    @notifications = @notifications.group_by { |i| [ i[:parent_type], i[:parent_id] ] }
    render "notifications/fetch", locals: {notifications: @notifications}
  end

end
