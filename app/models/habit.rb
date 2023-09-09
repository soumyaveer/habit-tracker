class Habit < ApplicationRecord
  has_many :user_habits, dependent: :destroy
  has_many :users, through: :user_habits

  validates :name, presence: true, uniqueness: true
  validates :status, inclusion: {
    in: %w(pending done missed),
    message: "%{value} is not a valid status"
  }

  validates :completed_before, presence: true

  def mark_complete!
    self.completed_at = DateTime.now
    if self.completed_at <= self.completed_before
      self.status = 'done'
    elsif self.completed_at > self.completed_before
      self.status = 'missed'
    end
  end

  # Does it make sense to check, if the current time is < completed_before then raise an error
  # 'Can't mark as missed'? 
  def mark_incomplete!
    self.completed_at = DateTime.now
    self.status = 'missed'
    self.save
  end
end
