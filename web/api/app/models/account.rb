class Account < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :groups, through: :group_accounts
  has_many :group_accounts, dependent: :destroy

  has_many :project_accounts
  has_many :projects, through: :project_accounts

  has_many :favorites, dependent: :destroy

  has_one :user, dependent: :destroy
  has_one :setting, dependent: :destroy

  before_create :build_default_setting
  before_create :build_default_user

  def user_name
    User.find_by(account_id: self.id).name
  end

  private

    def build_default_setting
      build_setting(
        :language => 'ja',
        :post_per => 10,
        :week_start => 'mon',
        :push_mail => true,
        :push_interval => 15,
      )
      true
    end

    def build_default_user
      build_user(
        :name => 'ユーザー名',
        :company => '',
        :birthday => '',
        :address => '',
        :url => '',
        :introduction => '',
        :image_name => 'default_user.jpg'
      )
      true
    end

end
