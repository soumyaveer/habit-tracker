# frozen_string_literal: true

class Habit < ApplicationRecord
  has_many :user_habits, dependent: :destroy
  has_many :users, through: :user_habits

  validates :name, presence: true, uniqueness: true
  validates :status, inclusion: {
    in: %w[pending done missed],
    message: '%<value>s is not a valid status'
  }

  validates :completed_before, presence: true

  scope :filter_by_dates, lambda { |start_date, end_date|
                            where('created_at >= :start_date AND created_at <= :end_date',
                                  { start_date:, end_date: })
                          }

  def mark_complete!
    self.completed_at = DateTime.now
    if completed_at <= completed_before
      self.status = 'done'
    elsif completed_at > completed_before
      self.status = 'missed'
    end
  end

  # Does it make sense to check, if the current time is < completed_before then raise an error
  # 'Can't mark as missed'?
  def mark_incomplete!
    self.completed_at = DateTime.now
    self.status = 'missed'
    save
  end

  def find_total_pages
    total_pages || 0
  end
end
