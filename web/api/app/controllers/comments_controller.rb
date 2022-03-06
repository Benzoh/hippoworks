class CommentsController < ApplicationController

  include NotificationUtility

  def create
    @comment = Comment.new(comment_params)
    logger.debug("!!params[:files] ========================================")
    logger.debug(comment_params.inspect)
    
    parent = Object.const_get(@comment.parent_type.classify).find_by(id: @comment.parent_id)

    logger.debug("@comment ========================================")
    logger.debug(parent.inspect)
    @comment.comment_index_id = parent.current_comment_index_id
    @comment.user_id = User.find_by(account_id: @current_account.id).id
    logger.debug(@comment.inspect)

    # 既読管理
    if @comment.parent_type == 'project' || @comment.parent_type == 'board'
      account_ids = @comment.get_joined_accounts(parent.group_id).pluck(:account_id)
    elsif @comment.parent_type == 'calendar'
      parent.calendar_groups.each do |group|
        account_ids = @comment.get_joined_accounts(group.group_id).pluck(:account_id)
      end
    end

    array = []
    account_ids.each do |account_id|
      next if account_id == @current_account.id
      id = User.find_by(account_id: account_id).id
      array.push({ user_id: id })
    end
    @comment.comment_recipients.new(array)

    if @comment.save && parent.increment(:current_comment_index_id).save  && save_notifications("comment", @comment)
      render :show
    else
      raise "保存できませんでした"
    end
  end

  def show
  end

  def destroy
    set_comment
    @comment.destroy

    redirect_back(fallback_location: root_path)
    flash[:success] = 'コメントを削除しました。'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(
        :title,
        :body,
        :parent_id,
        :parent_type,
        :comment_index_id,
        :user_id,
        uploads: []
      )
    end

end