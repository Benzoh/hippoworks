class CalendarsController < ApplicationController

  require './app/decorators/class_factory'
  include AlreadyRead
  include NotificationUtility

  before_action :set_calendar, only: [:show, :edit, :update, :destroy]
  before_action only: [:show, :edit, :update, :destroy] do
    create_association_class(@calendar.slug)
  end

  # GET /calendars
  # GET /calendars.json
  def index
    redirect_to weekly_calendar_path
  end

  def agenda
    if params[:starting_point]
      starting_point = params[:starting_point].split('-').map {|item|
        item.to_i
      }
      @time = Time.new(starting_point[0], starting_point[1], starting_point[2])
    else
      @time = Time.zone.now
    end

    calendars = Calendar.where(account_id: @current_account.id).where('start_time_epoc >= ? AND end_time_epoc <= ?', @time.to_i, @time.since(4.months).to_i)

    pre_group_calendars = CalendarGroup.where(group_id: @joined_groups.pluck(:id))
    group_calendars = Calendar.where(id: pre_group_calendars.pluck(:calendar_id)).where('start_time_epoc >= ? AND end_time_epoc <= ?', @time.to_i, @time.since(4.months).to_i)

    @calendars = calendars.or(group_calendars)
    # raise
  end

  def weekly
    if params[:starting_point]
      starting_point = params[:starting_point].split('-').map {|item|
        item.to_i
      }
      @time = Time.new(starting_point[0], starting_point[1], starting_point[2])
    else
      @time = Time.zone.now
    end
  end

  # GET /calendars/1
  # GET /calendars/1.json
  def show
    # Notification取得
    notifications = get_notifications("calendar", @current_account.id)
    # unread classの差し込みためのID取得
    @nids = notifications.pluck(:thread_id)
    # Notificationの削除
    notifications.delete_all if notifications.present?

    # like通知の削除
    like_notifications = LikeNotification.where(
      parent_type: 'calendar', parent_id: @calendar.id, user_id: @current_user.id)
    like_notifications.delete_all if like_notifications.present?

    if (params[:focus] && params[:cid])
      @comments = Comment.where(id: params[:cid])
    else
      @comments = Comment.where(parent_type: 'calendar', parent_id: @calendar.id).order("created_at DESC")
    end
    # raise

    gon.calendar = @calendar
  end

  # GET /calendars/new
  def new
    @calendar = Calendar.new

    if params[:start_date]
      start_date = params[:start_date].split('-')
    else
      start_date = Time.zone.now.strftime("%Y-%m-%d").split('-')
    end
    
    @calendar.start_year = start_date[0]
    @calendar.start_month = start_date[1]
    @calendar.start_day = start_date[2]
    @calendar.end_year = start_date[0]
    @calendar.end_month = start_date[1]
    @calendar.end_day = start_date[2]
    
    # raise
    # @calendar.calendar_groups.build
  end

  # GET /calendars/1/edit
  def edit
  end

  # POST /calendars
  # POST /calendars.json
  def create
    @calendar = Calendar.new(calendar_params)

    @calendar.start_time_epoc = Time.new(@calendar.start_year, @calendar.start_month, @calendar.start_day).to_i
    @calendar.end_time_epoc = Time.new(@calendar.end_year, @calendar.end_month, @calendar.end_day).to_i
    @calendar.account_id = @current_account.id
    @calendar.slug = SecureRandom.hex(5)
    @calendar.user_id = @current_user.id

    if ['repeat', 'period'].include?(@calendar.mode)
      # TODO: 期間・繰り返し予定の保存処理
      raise "未実装です"
    end

    respond_to do |format|
      if @calendar.save && save_notifications("calendar", @calendar)
        format.html { redirect_to @calendar, notice: 'Calendar was successfully created.' }
        format.json { render :show, status: :created, location: @calendar }
      else
        format.html { render :new }
        format.json { render json: @calendar.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /calendars/1
  # PATCH/PUT /calendars/1.json
  def update
    @calendar.start_time_epoc = Time.new(@calendar.start_year, @calendar.start_month, @calendar.start_day).to_i
    @calendar.end_time_epoc = Time.new(@calendar.end_year, @calendar.end_month, @calendar.end_day).to_i

    respond_to do |format|
      if @calendar.update(calendar_params)
        format.html { redirect_to @calendar, notice: 'Calendar was successfully updated.' }
        format.json { render :show, status: :ok, location: @calendar }
      else
        format.html { render :edit }
        format.json { render json: @calendar.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /calendars/1
  # DELETE /calendars/1.json
  def destroy
    @calendar.destroy

    # 関連テーブルも削除する
    ActiveRecord::Base.connection.drop_table("_comment_calendar_#{@calendar.slug}")
    ActiveRecord::Base.connection.drop_table("_comment_calendar_recipient_#{@calendar.slug}")

    respond_to do |format|
      format.html { redirect_to calendars_url, notice: 'Calendar was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def create_comment

    @calendar = Calendar.find(params[:calendar_id])

    # クラス生成
    create_association_class(@calendar.slug)

    @comment = Comment.new(
      title: params[:title],
      body: params[:body],
      account_id: current_account.id
    )

    account_ids = @calendar.get_joined_accounts(
      @calendar.calendar_groups.pluck(:group_id)
    ).pluck(:account_id)

    array = []
    account_ids.each do |account_id|
      id = User.find_by(account_id: account_id).id
      array.push({ user_id: id })
    end

    if @comment.save
      array.each do |index|
        cr = CommentRecipient.new(index)
        cr["comment_calendar_#{@calendar.slug}_id"] = @comment.id
        cr.save
      end

      render :comment_show
    else
      raise
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_calendar
      @calendar = Calendar.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def calendar_params
      params.require(:calendar).permit(
        :account_id,
        :user_id,
        :name,
        :description,
        :start_year,
        :start_month,
        :start_day,
        :start_hour,
        :start_minute,
        :end_year,
        :end_month,
        :end_day,
        :end_hour,
        :end_minute,
        :mode,
        :repeat_condition_type,
        :repeat_condition_day_of_week,
        :period_unlimited,
        :start_time_epoc,
        :end_time_epoc,
        :updated_account_id,
        :slug,
        group_ids: [],
        uploads: [],
      )
    end

    # クラス生成
    def create_association_class(calendar_slug)
      # raise
      ClassFactory.create_class('Comment', "_comment_calendar_#{calendar_slug}", ENV["RAILS_ENV"].to_sym)
      ClassFactory.create_class('CommentRecipient', "_comment_calendar_recipient_#{calendar_slug}", ENV["RAILS_ENV"].to_sym)
    end
end
