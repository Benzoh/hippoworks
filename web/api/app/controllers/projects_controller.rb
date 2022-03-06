class ProjectsController < ApplicationController

  include ConvertTime
  include AlreadyRead
  include NotificationUtility

  before_action :authenticate_account!
  before_action :set_project, only: [:show, :edit, :update, :destroy, :dashboard]
  before_action :joined_current_group?, except: [:joined_projects]

  # GET /projects
  # GET /projects.json
  def index
    @group = Group.find_by id: params[:group_id]
    @projects = Project.where(group_id: @group.id)

    if params[:filter].present?
      @projects =
        Project.project_sort_filter(
          @projects,
          params[:account],
          params[:status],
          params[:priority],
          params[:sort]
        )
    end

    # ページネーション
    @projects = @projects.page(params[:page]).per(20)
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
  end

  # GET /projects/new
  def new
    @group = Group.find_by id: params[:group_id]
    @group_members = @group.group_accounts.map do |ga|
      Account.find_by(id: ga.account_id)
    end
    # raise
    @project = Project.new(group_id: @group.id)
    # @project = @current_account.projects.new(group_id: @group.id)
    # @project.project_accounts.build
    @project.build_timer
    # raise
  end

  # GET /projects/1/edit
  def edit
    @group = Group.find_by id: params[:group_id]
    @group_members = @group.group_accounts.map do |ga|
      Account.find_by(id: ga.account_id)
    end
    # raise
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)
    @project.user_id = @current_user.id
    respond_to do |format|
      if @project.save && save_notifications("project", @project)
        format.html { redirect_to group_dashboard_path(id: @project.id), notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        # raise
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to group_dashboard_path(id: @project.id), notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    # TODO: 関連データの削除
    # [x] comment
    # [x] like
    # [x] favorite
    # [ ] commentのlike
    # [ ] ??
    comments = Comment.where(parent_id: @project.id, parent_type: 'project')
    comments.delete_all
    likes = Like.where(thread_id: @project.id, thread_type: 'project')
    likes.delete_all
    favorites = Favorite.where(parent_id: @project.id, parent_type: 'project')
    favorites.delete_all
    @project.destroy
    respond_to do |format|
      format.html { redirect_to group_projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET /projects/1/dashboard
  def dashboard
    # Notification取得
    notifications = get_notifications("project", @current_account.id)
    # unread classの差し込みためのID取得
    @nids = notifications.pluck(:thread_id)
    # Notificationの削除
    notifications.delete_all if notifications.present?

    # like通知の削除
    like_notifications = LikeNotification.where(
      parent_type: 'project', parent_id: @project.id, user_id: @current_user.id)
    like_notifications.delete_all if like_notifications.present?

    @group = Group.find_by(id: @project.group_id)
    # @entry_users = EntryProject.where(project_id: @project.id)
    entry_users = @project.accounts.map do |account|
      User.find_by(account_id: account.id)
    end
    @entry_users = entry_users.pluck(:name)
    # raise

    if (params[:focus] && params[:cid])
      @comments = Comment.where(id: params[:cid])
    else
      @comments = Comment.where(parent_type: 'project', parent_id: @project.id).order("created_at DESC")
    end

    @memos = Memo.where(project_id: @project.id).order("created_at DESC")
    # 既読処理
    already_read(@memos.first.id) if @memos.blank? == false

    gon.project = @project
    gon.push({
      :timer => @project.timer,
    })
  end

  # TODO: コントローラー分けてもいいかも
  def joined_projects

    @joined_groups = @current_account.group_accounts.map do |group|
      Group.find_by(id: group.group_id)
    end

    @projects = Project.get_joined_projects(@current_account.id)

    if params[:filter].present?
      @projects =
        Project.sort_filter(@projects, params[:group], params[:status], params[:sort])
    end

    # ページネーション
    @projects = @projects.page(params[:page]).per(10)

    render :template => "projects/joined_project"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(
        :name,
        :number,
        :delivery_date,
        # :charge_user_id,
        :user_id,
        :priority,
        :status_id,
        :category_id,
        :group_id,
        :description,
        account_ids: [],
        uploads: [],
        timer_attributes: [
          :secs,
          :project_id,
          :h,
          :m,
          :s
        ],
      )
    end

    # TODO: リファクタリング？ - group_controllerにも置いてるので
    def joined_current_group?
      if @joined_groups.pluck(:id).include?(params[:group_id].to_i) == false
        raise "Don't have authority."
      end
    end

end
