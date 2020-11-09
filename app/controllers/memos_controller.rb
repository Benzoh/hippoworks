class MemosController < ApplicationController

  include AlreadyRead
  
  before_action :set_memo, only: [:show, :edit, :update, :destroy]
  before_action :set_project, only: [:edit]

  # GET /memos
  # GET /memos.json
  def index
    @memos = Memo.all
  end

  # GET /memos/1
  # GET /memos/1.json
  def show
  end

  # GET /memos/new
  def new
    @memo = Memo.new
  end

  # GET /memos/1/edit
  def edit
  end

  # POST /memos
  # POST /memos.json
  def create
    # TODO: リファクタリング
    @memo = Memo.new(
      title: params[:title],
      body: params[:body],
      project_id: params[:project_id],
      account_id: current_account.id
    )

    # TODO: 現在参加しているグループのメンバーID
    account_ids = @memo.get_joined_accounts(
      Project.find_by(id: params[:project_id]).group_id
    ).pluck(:account_id)

    logger.debug("Debug ========================================")
    logger.debug(account_ids.inspect)

    array = []
    account_ids.each do |account_id|
      id = User.find_by(account_id: account_id).id
      array.push({ user_id: id })
    end

    logger.debug("Debug ========================================")
    logger.debug(array)

    @memo.memo_recipients.new(array)

    if @memo.save
      render :show
    else
      raise
    end
  end

  # PATCH/PUT /memos/1
  # PATCH/PUT /memos/1.json
  def update
    respond_to do |format|
      if @memo.update(memo_params)
        format.html { redirect_to "/projects/#{@memo.project_id}/dashboard" }
        flash[:success] = 'Memoを更新しました。'
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /memos/1
  # DELETE /memos/1.json
  def destroy
    @memo.destroy
    respond_to do |format|
      format.html { redirect_to "/projects/#{@memo.project_id}/dashboard" }
      flash[:success] = 'Memoを削除しました。'
    end
  end

  # PATCH/PUT /memos/1/is_read
  def mark_as_read
    if already_read(params[:id])
      render "memos/mark_as_read", locals: {memo_id: params[:id]}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_memo
      @memo = Memo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def memo_params
      params.require(:memo).permit(:title, :body, :project_id)
    end

    def set_project
      @project = Project.find(@memo.project_id)
    end

end
