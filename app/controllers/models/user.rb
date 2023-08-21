class User < ApplicationRecord
  has_many :user_habits, dependant: :destroy
  has_many :habits, through: :user_habits
end
