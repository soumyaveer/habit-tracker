def user_attributes
  {
    email: Faker::Internet.email,
    name: Faker::Lorem.name,
    password: Faker::Internet.word
  }
end

def habit_attributes(status: 'pending')
  {
    name: Faker::Hobby.activity,
    status: status
    completed_at: (DateTime.now if status == 'pending'
    completed_before: 1.day.from.now
  }
end

def create_habit(attributes = {})
  Habit.create!(book_attributes.merge(attributes))
end

def create_user(attributes = {})
  User.create!(user_attributes.merge(attributes))
end

