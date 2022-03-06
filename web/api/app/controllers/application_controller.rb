class ApplicationController < ActionController::Base

  before_action :request_path
  before_action :set_search_param
  before_action :get_current_account
  before_action :joined_groups
  before_action :init
  before_action :current_user_id
  before_action :set_likes
  before_action :set_favorites

  def init
    @wd = ["日", "月", "火", "水", "木", "金", "土"]
    current_account.present? ? gon.login = true : gon.login = false
  end

  def request_path
    @loading_action = controller_path + '#' + action_name
  end

  # TODO: 仮設置
  def set_search_param
    @q = Memo.search(params[:q])
  end

  def get_current_account
    @current_account = current_account
  end

  def joined_groups
    if @current_account.blank?
      redirect_to new_account_session_path
      return
    end
    # TODO: not work??
    ids = @current_account.group_accounts.where(account_id: @current_account.id).pluck(:group_id)
    # raise
    @joined_groups = Group.where(id: ids)
  end

  def current_user_id
    return if @current_account.blank?

    @current_user = User.find_by(account_id: @current_account.id)
    @current_user.id
  end

  def set_likes
    return if @current_user.blank?
    likes = LikeNotification.where(user_id: @current_user.id);
    @likes = likes.group_by { |item| [item.parent_type, item.parent_id] }
    # raise
  end

  def set_favorites
    return if @current_account.blank?
    @nav_favorites = @current_account.favorites.order(created_at: :desc).take(5)
    # raise
  end
end
