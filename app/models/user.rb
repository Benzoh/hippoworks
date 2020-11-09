class User < ApplicationRecord
  belongs_to :account, dependent: :destroy
end
