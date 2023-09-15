class HabitsController < ApplicationController
  DEFAULT_PAGE_NUMBER = 1.freeze
  DEFAULT_PAGE_SIZE = 3.freeze

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
    habits = Habit.order(:id).page(page_number).per(page_size)
    
    if params[:from].present? && params[:to].present? 
      habits = habits.filter_by_dates(Time.parse(params[:from]), Time.parse(params[:to]))
    end
    all_habits = habits.map do |habit| 
      user = if params[:include] == 'user'
        user_habit = UserHabit.find_by(habit_id: habit.id) 
        user_habit&.user ?  user_habit.user : nil
      end
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

  post '/api/habits/:id/missed' do
    habit = Habit.find(params[:id])  
    if habit
      
      if habit.mark_incomplete!
        user_habit = UserHabit.find_by(habit_id: habit.id)
        user = user_habit.user
        json present_resource(habit, "habit").merge(present_relationship_data(user, 'user'))
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

  patch '/api/habits/:id' do
    habit = Habit.find(params[:id])
    habit.name = json_req_body_attrs[:name]

    if habit.save
      user = UserHabit.find_by(habit_id: habit.id)
      json present_resource(habit, "habit").merge(present_relationship_data(user, 'user'))
    else
      status(422)
      habit_json = habit.as_json
      habit_json[:errors] = habit.errors.full_messages

      json present_resource(habit_json, 'habit') 
    end
  end

  private

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

  # TODO: How to calculate total_pages 
  def metadata
    {
      meta: {
        totalPages: total_pages
      }
    }.as_json
  end

  # TODO: How to calculat and return links
  def links
    {
      links: {
        self: request.original_url,
        first: first_page_url(request.original_url),
        prev: prev_page_url(request.original_url),
        next: next_page_url(request.original_url),
        last: last_page_url(request.original_url)
      }
  }.as_json
  end

  def page_number
    params[:page] && params[:page][:number] ? params[:page][:number] : DEFAULT_PAGE_NUMBER
  end

  def page_size
    params[:page] && params[:page][:size] ? params[:page][:size] : DEFAULT_PAGE_SIZE
  end
end