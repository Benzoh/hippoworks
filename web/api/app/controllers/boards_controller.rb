class BoardsController < ApplicationController

  include NotificationUtility

  def index
    @group = Group.find_by id: params[:group_id]
    @boards = @group.boards
  end

  def show
    @group = Group.find_by id: params[:group_id]
    @board = Board.find(params[:id])

    # Notification取得
    notifications = get_notifications("board", @current_account.id)
    # unread classの差し込みためのID取得
    @nids = notifications.pluck(:thread_id)
    # Notificationの削除
    notifications.delete_all if notifications.present?

    if (params[:focus] && params[:cid])
      @comments = Comment.where(id: params[:cid])
    else
      @comments = Comment.where(parent_type: 'board', parent_id: @board.id).order("created_at DESC")
    end
  end

  def new
    @board = Board.new
    @board.group_id = params[:group_id]
  end

  def create
    @board = Board.new(board_params)
    @board.user_id = @current_user.id
    respond_to do |format|
      if @board.save
        format.html { redirect_to group_board_path(id: @board.id), notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @board }
      else
        # raise
        format.html { render :new }
        format.json { render json: @board.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  private

    def board_params
      params.require(:board).permit(
        :name,
        :user_id,
        :category_id,
        :group_id,
        :description
      )
    end

    # TODO: リファクタリング？ - group_controllerにも置いてるので
    def joined_current_group?
      if @joined_groups.pluck(:id).include?(params[:group_id].to_i) == false
        raise "Don't have authority."
      end
    end

end
