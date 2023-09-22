# frozen_string_literal: true

def user_attributes
  {
    email: Faker::Internet.email,
    name: Faker::Lorem.name,
    password: Faker::Internet.password
  }
end

def habit_attributes
  {
    name: Faker::Hobby.activity,
    status: 'pending',
    completed_at: nil,
    completed_before: 1.day.from.now
  }
end

def create_habit(attributes = {})
  Habit.create!(book_attributes.merge(attributes))
end

def create_user(attributes = {})
  User.create!(user_attributes.merge(attributes))
end
