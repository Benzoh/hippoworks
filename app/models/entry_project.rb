class EntryProject < ApplicationRecord
  belongs_to :project
  belongs_to :account
end
