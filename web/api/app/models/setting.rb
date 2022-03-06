class Setting < ApplicationRecord
  belongs_to :account, dependent: :destroy
end
