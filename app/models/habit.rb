class Habit < ApplicationRecord
  has_many :user_habits, dependent: :destroy
  has_many :users, through: :user_habits

  validates :name, presence: true, uniqueness: true
  validates :status, inclusion: {
    in: %w(pending done missed),
    message: "%{value} is not a valid status"
  }

  validates :completed_before, presence: true
end
