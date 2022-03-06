class Calendar < ApplicationRecord

  include GroupModule

  has_many :calendar_groups, dependent: :destroy
  has_many :groups, through: :calendar_groups
  has_many :comments, dependent: :destroy

  has_many_attached :uploads

  # 開始と終了のタイムスタンプの間にスケジュールの開始時間と終了時間が含まれるか
  def self.get_schedule_with_duration(account_id, time_epoc, joined_groups)
    my_calendars = self.where(account_id: account_id).where('start_time_epoc <= ? AND end_time_epoc >= ?', time_epoc, time_epoc)

    pre_group_calendars = CalendarGroup.where(group_id: joined_groups.pluck(:id))
    group_calendars = self.where(id: pre_group_calendars.pluck(:calendar_id)).where('start_time_epoc <= ? AND end_time_epoc >= ?', time_epoc, time_epoc)

    my_calendars.or(group_calendars)
    # raise
  end

  def self.get_calendar(start_year, start_month, start_day)
    return self.where(
      start_year: start_year,
      start_month: start_month,
      start_day: start_day
    )
  end

  # 動的にテーブル生成（コメント用）
  def create_comment_table
    connection = ActiveRecord::Base.connection
    table_name = "_comment_calendar_#{self.slug}"

    connection.create_table(table_name) do |t|
      t.string :title
      t.text :body
      t.string :calendar_slug, unique: true, default: self.slug
      t.integer :account_id
      t.timestamps
    end
  end

  # 動的にテーブル生成（コメントの既読管理用）
  def create_comment_recipient_table
    connection = ActiveRecord::Base.connection
    table_name = "_comment_calendar_recipient_#{self.slug}"

    connection.create_table(table_name) do |t|
      t.integer :is_read, default: 0
      t.integer :user_id
      t.integer "comment_calendar_#{self.slug}_id"
      t.timestamps
    end
  end

end
