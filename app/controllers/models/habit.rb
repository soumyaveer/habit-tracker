class Habit < ApplicationRecord
  has_many :user_habits, dependant: :destroy
  has_many :users, through: :user_habits
end
