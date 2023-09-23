# frozen_string_literal: true

class User < ApplicationRecord
  attr_accessor :skip_password

  has_many :user_habits, dependent: :destroy
  has_many :habits, through: :user_habits

  has_secure_password

  validates :name, presence: true
  validates :email, presence: true,
                    format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates :name, :email, uniqueness: true
  validates :password, presence: true, unless: :skip_password
end
