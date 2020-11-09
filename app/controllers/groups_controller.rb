class GroupsController < ApplicationController
  before_action :authenticate_account!, only: [:index]
  before_action :get_current_account
  before_action :joined_groups
  before_action :joined_current_group?, except: [:index, :new, :create]
  before_action :set_group, only: [:show, :edit, :update, :destroy]

  # root
  # GET /groups
  # GET /groups.json
  def index
    # TODO: calendarのアップデートが考慮されていない
    all_updates = Group.get_all_updates(current_user_id)
    @group_all_updates = Hash.new { |h,k| h[k] = {} }
    all_updates.each do |parent_id, comments|
      project = Project.find_by(id: parent_id)
      next if project.blank?
      group_id = project.group_id
      @group_all_updates[group_id.to_s][parent_id] = comments
    end
    # raise

    # project_updates = Group.get_project_updates(current_user_id)
    # @group_project_updates = Hash.new { |h,k| h[k] = {} }
    # project_updates.each do |parent_id, comments|
    #   group_id = Project.find_by(id: parent_id).group_id
    #   @group_project_updates[group_id.to_s][parent_id] = comments
    # end
    # raise

    @wd = ["日", "月", "火", "水", "木", "金", "土"]
    if params[:starting_point]
      starting_point = params[:starting_point].split('-').map {|item|
        item.to_i
      }
      @time = Time.new(starting_point[0], starting_point[1], starting_point[2])
    else
      @time = Time.zone.now
    end
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
    @project_updates = Group.get_project_updates(current_user_id, params[:id])
    @calendar_updates = Group.get_calendar_updates(current_user_id, params[:id])
  end

  # GET /groups/new
  def new
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = Group.new(group_params)

    # TODO: association?
    if @group.save
      @group_account = GroupAccount.new(
        group_id: @group.id,
        account_id: @current_account.id
      )
    end

    respond_to do |format|
      if @group_account.save
        format.html { redirect_to @group, notice: 'Group was successfully created.' }
        format.json { render :show, status: :created, location: @group }
      else
        format.html { render :new }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to @group, notice: 'Group was successfully updated.' }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :edit }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group.destroy
    respond_to do |format|
      format.html { redirect_to groups_url, notice: 'Group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_params
      params.require(:group).permit(
        :name,
        :create_account_id,
        :notice,
        :invitation_authority,
        :icon_img,
      )
    end

    def get_current_account
      @current_account = current_account
      if @current_account.blank?
        redirect_to new_account_session_path
      end
    end

    def joined_groups
      if @current_account.blank?
        redirect_to new_account_session_path
      end
      # TODO: not work??
      ids = @current_account.group_accounts.where(account_id: @current_account.id).pluck(:group_id)
      # raise
      @joined_groups = Group.where(id: ids)
    end

    def joined_current_group?
      if @joined_groups.pluck(:id).include?(params[:id].to_i) == false
        raise "Don't have authority."
      end
    end
end
