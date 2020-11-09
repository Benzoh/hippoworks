class Task < ApplicationRecord
  belongs_to :project
  has_one :working_hour, dependent: :destroy
end
