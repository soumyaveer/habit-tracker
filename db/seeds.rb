# frozen_string_literal: true

User.destroy_all
Habit.destroy_all
UserHabit.destroy_all

# TODO: set up seed data
users = []
5.times do
  users << User.create(
    name: Faker::Internet.username,
    email: Faker::Internet.email,
    password: Faker::Internet.password,
    disabled_at: nil
  )
end

pending_habits = []
5.times do
  pending_habits << Habit.create(
    name: Faker::Hobby.activity,
    status: 'pending',
    completed_at: nil,
    completed_before: DateTime.now + 1
  )
end

missed_habits = []
5.times do
  missed_habits << Habit.create(
    name: Faker::Hobby.activity,
    status: 'missed',
    completed_at: nil,
    completed_before: 1.day.ago
  )
end

completed_habits = []
5.times do
  completed_habits << Habit.create(
    name: Faker::Hobby.activity,
    status: 'done',
    completed_at: DateTime.now - 0.5,
    completed_before: DateTime.now - 0.5
  )
end

users.each do |user|
  3.times do
    UserHabit.create(
      user:,
      habit: [pending_habits, missed_habits, completed_habits].flatten.sample
    )
  end
end
