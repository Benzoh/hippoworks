class Group < ApplicationRecord
  has_many :accounts, through: :group_accounts
  has_many :group_accounts
  accepts_nested_attributes_for :group_accounts

  has_many :projects, through: :group_projects
  has_many :group_projects
  accepts_nested_attributes_for :group_projects

  has_many :calendar_groups
  has_many :calendars, through: :calendar_groups

  has_many :boards, dependent: :destroy
  has_many :cabinets, dependent: :destroy

  scope :with_project, -> { joins(:projects) }
  scope :search_with_group_id, ->(group_id) { where(group_id: group_id) }

  def self.get_all_updates(current_user_id)
    pu = Notification.where(user_id: current_user_id).order(id: :desc)
    grouped = pu.group_by { |item| item.parent_type }
    comment_group = pu.group_by { |item| item.thread_type }['comment']

    project_updates = Hash.new { |h, k| h[k] = {} }
    calendar_updates = Hash.new { |h, k| h[k] = {} }

    if grouped["project"].present?
      grouped["project"].each do |item|
        project_updates[item.parent_id.to_s] = []
        if item.parent_type == item.thread_type
          project_updates[item.parent_id.to_s].push(item)
        end
      end
      # raise
    end

    if grouped["calendar"].present?
      grouped["calendar"].each do |item|
        calendar_updates[item.parent_id.to_s] = []
        if item.parent_type == item.thread_type
          calendar_updates[item.parent_id.to_s].push(item)
        end
      end
      # raise
    end

    if comment_group.present?
      comment_group.each do |item|
        comment = Comment.find_by(id: item.thread_id)
        parent_type = Comment.find_by(id: item.thread_id).parent_type
        if parent_type == 'project'
          parent = Object.const_get(parent_type.classify).find_by(id: comment.parent_id)
          project_updates[parent.id.to_s].push(comment)
        end

        if parent_type == 'calendar'
          parent = Object.const_get(parent_type.classify).find_by(id: comment.parent_id)
          calendar_updates[parent.id.to_s].push(comment)
        end
        # raise
      end
    end
    
    updates = Hash.new
    updates = project_updates.merge(calendar_updates)
    # raise
  end

  def self.get_project_updates(current_user_id, group_id = nil)
    pu = Notification.where(user_id: current_user_id).order(id: :desc)
    grouped = pu.group_by { |item| item.parent_type }
    comment_group = pu.group_by { |item| item.thread_type }['comment']

    project_updates = Hash.new { |h, k| h[k] = {} }

    if grouped["project"].present?
      grouped["project"].each do |item|
        project_updates[item.parent_id.to_s] = []
        if item.parent_type == item.thread_type
          project_updates[item.parent_id.to_s].push(item)
        end
      end
      # raise
    end

    if comment_group.present?
      comment_group.each do |item|
        comment = Comment.find_by(id: item.thread_id)
        parent_type = Comment.find_by(id: item.thread_id).parent_type
        if parent_type == 'project'
          parent = Object.const_get(parent_type.classify).find_by(id: comment.parent_id)
          project_updates[parent.id.to_s].push(comment)
        end
      end
    end

    # groupに絞る
    # TODO: リファクタリングもっと事前に処理できるはず
    if group_id.present?
      project_updates.each do |update|
        project = Project.find_by(id: update[0], group_id: group_id)
        project_updates.delete(update[0]) if project.blank?
      end
    end

    project_updates
  end

  def self.get_calendar_updates(current_user_id, group_id = nil)
    pu = Notification.where(user_id: current_user_id).order(id: :desc)
    grouped = pu.group_by { |item| item.parent_type }
    comment_group = pu.group_by { |item| item.thread_type }['comment']

    calendar_updates = Hash.new { |h, k| h[k] = {} }

    if grouped["calendar"].present?
      grouped["calendar"].each do |item|
        calendar_updates[item.parent_id.to_s] = []
        if item.parent_type == item.thread_type
          calendar_updates[item.parent_id.to_s].push(item)
        end
      end
      # raise
    end

    if comment_group.present?
      comment_group.each do |item|
        comment = Comment.find_by(id: item.thread_id)
        parent_type = Comment.find_by(id: item.thread_id).parent_type
        if parent_type == 'calendar'
          parent = Object.const_get(parent_type.classify).find_by(id: comment.parent_id)
          calendar_updates[parent.id.to_s].push(comment)
        end
        # raise
      end
    end

    # groupに絞る
    # TODO: リファクタリングもっと事前に処理できるはず
    if group_id.present?
      calendar_updates.each do |update|
        calendar = Calendar.find_by(id: update[0])
        if calendar.groups.pluck(:id).include?(group_id.to_i) == false
          calendar_updates.delete(update[0])
        end
      end
    end

    calendar_updates
  end
end
