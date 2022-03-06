class InvitesController < ApplicationController
  # before_action :set_group, only: [:show, :edit, :update, :destroy]
  before_action :set_invite, only: [:show, :edit, :update, :destroy, :token]
  skip_before_action :joined_groups, only: [:token]

  # GET /invites
  # GET /invites.json
  def index
    @invites = Invite.all
  end

  # GET /invites/1
  # GET /invites/1.json
  def show
  end

  # GET /invites/new
  def new
    @invite = Invite.new
  end

  # GET /invites/1/edit
  def edit
  end

  # POST /invites
  # POST /invites.json
  def create
    mail_addresses = params[:invite]['mail_to']
    mail_addresses_array = mail_addresses.split(/\r\n/)

    if mail_addresses_array.instance_of?(Array)
      mail_addresses_array.each do |mail|

        invite = Invite.new(invite_params)
        invite.build_token
        invite.mail_to = mail
        invite.account_id = @current_account.id
        invite.group_id = params[:group_id]
        invite.state = '招待中'

        # Token発行
        token = SecureRandom.uuid
        invite.token.attributes = { uuid: token, expired_at: 24.hours.since }

        if invite.save!
          # raise
          InviteMail.with(invite: invite, group_id: params[:group_id], uuid: token).invite.deliver_later
        end
      end
      respond_to do |format|
        format.html { redirect_to group_invites_path(id: params[:group_id]), notice: 'Invite was successfully created.' }
      end
    end
    # TODO: エラー時の対応
  end

  def token
    token = Token.find_by(uuid: params[:uuid])
    if token && token.expired_at > Time.now
      # MEMO： アップデートするタイミングはやいかな？？
      token.update_attributes!(expired_at: Time.now)

      # TODO: 存在するアカウントで、ログインしてないときの処理が必要
      if @account = Account.find_by(email: token.invite.mail_to)
        @group_account = GroupAccount.new(
          group_id: params[:group_id],
          account_id: @account.id
        )
        if @group_account.save
          # 招待の削除処理
          @invite.destroy
          redirect_to group_path(params[:group_id]), notice: 'グループにジョインしました。'
        end

      # TODO: ユーザー登録がまだの場合、アカウント作成後グループにジョインする
      else
        respond_to do |format|
          format.html { redirect_to new_account_registration_path(invite_id: token.invite.id) }
          flash[:success] = 'アカウントを作成してください。'
        end
      end
    else
      redirect_to group_invite_error_path
      flash[:danger] = 'URLが不正です。'
    end
  end

  def error
    # TODO: エラー処理
    # raise
  end

  # PATCH/PUT /invites/1
  # PATCH/PUT /invites/1.json
  def update
    respond_to do |format|
      if @invite.update(invite_params)
        format.html { redirect_to @invite, notice: 'Invite was successfully updated.' }
        format.json { render :show, status: :ok, location: @invite }
      else
        format.html { render :edit }
        format.json { render json: @invite.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /invites/1
  # DELETE /invites/1.json
  def destroy
    @invite.destroy
    respond_to do |format|
      format.html { redirect_to group_invites_path, notice: 'Invite was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    # 既存ユーザチェック
    def account_created?(email)
      tmp_account = Account.find_by_email(email)
      return true if tmp_account.blank? == false
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_invite
      if params[:invite_id]
        @invite = Invite.find(params[:invite_id])
      else
        @invite = Invite.find(params[:id])
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def invite_params
      params.require(:invite).permit(:mail_to, :account_id, :state)
    end

end
