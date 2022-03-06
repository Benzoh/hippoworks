class InviteMail < ActionMailer::Base
  # デフォルトでの送信元のアドレス
  # default from: 'invite@infinite-anchorage-11918.herokuapp.com'
  default from: ENV['INVITE_FROM_MAIL_ADDRESS']

  def invite
    @invite = params[:invite]
    # TODO: URL変更
    @url = "#{ENV['APP_SERVER_HOST']}/groups/#{params[:group_id]}/invites/#{@invite.id}/token/#{params[:uuid]}"
    # @url  = "http://localhost:3000/groups/#{params[:group_id]}/invites/#{@invite.id}/token/#{params[:uuid]}"
    mail(
      # TOは単体のメールアドレスでもArrayのメールアドレスでも大丈夫
      to: @invite.mail_to,
      subject: 'グループへの招待メール | HippoWorks',
    ) do |format|
      format.html
    end
  end
end