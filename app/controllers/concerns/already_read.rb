require 'active_support/concern'

module AlreadyRead
  extend ActiveSupport::Concern

  included do
    # ここにcallback等
    # scope :disabled, -> { where(disabled: true) }
  end

  def already_read(memo_id)
    user_id = User.find_by(account_id: @current_account.id).id
    # memo_recipient = MemoRecipient.find_by(memo_id: params[:id])
    memo_recipients = MemoRecipient.where(user_id: user_id, is_read: false).where(
      "memo_id <= #{memo_id}")
    logger.debug("Debug ========================================")
    logger.debug(memo_recipients.inspect)
    if memo_recipients.blank? == false
      memo_recipients.each do |memo_recipient|
        memo_recipient['is_read'] = true
        memo_recipient.save!
      end
    end
    return true
  end

end