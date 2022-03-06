class ProjectAccount < ApplicationRecord
  belongs_to :account
  belongs_to :project
end
