class User < ApplicationRecord
  has_many :user_habits, dependant: :destroy
  has_many :habits, through: :user_habits

  has_secure_password

  validates :name, presence: true
  validates :email, presence: true,
                    format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates :name, :email, uniqueness: true
  validates :password, presence: true
end
