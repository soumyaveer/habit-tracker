class HabitsController < ApplicationController
  post '/api/habits' do
      habit = Habit.new(
        name: json_req_body_attrs[:name],
        status: 'pending',
        completed_before: DateTime.now + 1
      )
  
      user = User.find(json_req_body_attrs[:user_id])
  
      user_habit = UserHabit.new(
        habit: habit,
        user: user
      )
     
    if habit.save && user_habit.save 
      json present_resource(habit, "habit")
    else
      status(422)
      habit_json = habit.as_json
      habit_json[:errors] = habit.errors.full_messages

      json present_resource(habit_json, 'habit') 
    end
  end

  get '/api/habits' do
    habits = Habit.all

    all_habits = habits.map do |habit| 
      user = UserHabit.find_by(habit_id: habit.id) 
      if user
        present_resource(habit, 'habit').merge(present_relationship_data(user, 'user_habit'))
      else
        present_resource(habit, 'habit')
      end
    end
    json all_habits
  end

  get '/api/habits/:id' do
    habit = Habit.find(params[:id])
    if habit
      user = UserHabit.find_by(habit_id: habit.id)
      json present_resource(habit, "habit").merge(present_relationship_data(user, 'user_habit'))
    else
      status(404)
    end
  end

  delete '/api/habits/:id' do
    habit = Habit.find(params[:id]) 
    if habit 
      habit.destroy!
      status(204)
    else
      status(404)
    end
  end

  post '/api/habits/:id/done' do
    habit = Habit.find(params[:id])  
    if habit
      habit.mark_complete!
      if habit.save
        user = UserHabit.find_by(habit_id: habit.id)
        json present_resource(habit, "habit").merge(present_relationship_data(user, 'user_habit'))
      else
        status(422)
        habit_json = habit.as_json
        habit_json[:errors] = habit.errors.full_messages

        json present_resource(habit_json, 'habit') 
      end
    else
      status(404)
    end
  end

  def json_req_body_attrs
    json_request_body[:data][:attributes]
  end

  def present_relationship_data(obj, resource_name)
    {
      "relationships": {
        "#{resource_name}":{
          "data": {
            "type": obj.class,
            "id": obj.id,
          }
        }
      }
    }.as_json
  end
end