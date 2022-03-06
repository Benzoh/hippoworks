class Project < ApplicationRecord

  has_many :group_accounts, foreign_key: 'group_id'
  has_many :accounts, through: :group_accounts
  accepts_nested_attributes_for :group_accounts

  has_many :project_accounts, dependent: :destroy
  has_many :accounts, through: :project_accounts

  # has_many :comments, dependent: :destroy
  # has_one :status
  has_one :category

  has_many :standard_operations, dependent: :destroy
  has_many :tasks, dependent: :destroy
  # has_many :memos, dependent: :destroy
  has_one :timer, dependent: :destroy
  accepts_nested_attributes_for :timer

  has_many_attached :uploads

  scope :with_memo, -> { joins(:memos) }
  scope :search_with_project_id, ->(project_id) { where(project_id: project_id) }

  def self.get_joined_projects(account_id)
    entry_projects = ProjectAccount.where(account_id: account_id)
    project_ids = []
    entry_projects.each do |ep|
      project_ids << ep.project_id
    end
    return self.where(id: project_ids)
  end

  def self.sort_filter(records, group = nil, status = nil, sort = nil)
    status = Status.all.pluck(:id) if status.blank?
    # TODO: リファクタリング
    if group.blank?
      return records.where(status_id: status).order(delivery_date: sort)
    else
      return records.where(group_id: group, status_id: status).order(delivery_date: sort)
    end
  end

  def self.project_sort_filter(records, account = nil, status = nil, priority = nil, sort = nil)
    status = Status.all.pluck(:id) if status.blank?
    priority = ["S", "A", "B", "C", "D"] if priority.blank?
    # TODO: リファクタリング
    if account.blank?
      return records.where(status_id: status, priority: priority).order(delivery_date: sort)
    else
      # TODO: accountでの検索 → いけてる？？
      return records.joins(:accounts)
        .where('accounts.id = ?', account)
        .where(status_id: status, priority: priority)
        .order(delivery_date: sort)
    end
  end

end
