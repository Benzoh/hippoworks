class Memo < ApplicationRecord
  include GroupModule

  belongs_to :project
  has_many :memo_recipients, dependent: :destroy

  scope :with_memo_recipient, -> { joins(:memo_recipients) }
  scope :not_read, -> { where(is_read: false) }
  # scope :search_with_is_read, -> { where(is_read: false) }

  # プロジェクトの更新を取ってくる
  # group - project - memo
  def self.get_group_project_update(group_id, user_id)
    project_ids = Project.where(group_id: group_id).pluck(:id)
    memos = self.where(project_id: project_ids).order("created_at DESC")
    # raise

    # 未読に絞る
    unread_memos = []
    memos.each do |memo|
      unread_memo = MemoRecipient.where(
        user_id: user_id, is_read: false, memo_id: memo.id)
      if unread_memo.blank? == false
        unread_memos.push(memo)
      end
    end
    # raise
    unread_memos
  end

  def self.get_all_group_project_update(account_id)
    group_ids = GroupAccount.where(account_id: account_id).pluck(:id)
    project_ids = Project.where(group_id: group_ids).pluck(:id)
    self.where(project_id: project_ids).order("created_at DESC")
    # raise
  end

  def self.get_not_read_memos(user_id)
    not_read_memos = MemoRecipient.where(
      user_id: user_id, is_read: false).pluck(:memo_id
    )
    self.where(id: not_read_memos).order(:project_id, {created_at: :DESC})
    # raise
  end
end
