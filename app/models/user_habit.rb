class UserHabit < ApplicationRecord
  belongs_to :user, required: true
  belongs_to :habit, required: true
end
