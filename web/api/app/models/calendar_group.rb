class CalendarGroup < ApplicationRecord
  belongs_to :calendar
  belongs_to :group
end
