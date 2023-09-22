# frozen_string_literal: true

class HabitsController < ApplicationController
  DEFAULT_PAGE_NUMBER = 1
  DEFAULT_PAGE_SIZE = 3

  post '/api/habits' do
    habit = Habit.new(
      name: json_req_body_attrs[:name],
      status: 'pending',
      completed_before: DateTime.now + 1
    )

    user = User.find(json_req_body_attrs[:user_id])

    user_habit = UserHabit.new(
      habit:,
      user:
    )

    if habit.save && user_habit.save
      json HabitPresenter.new(object: habit, type: 'Habit').present_user
    else
      status(422)
      habit_json = habit.as_json
      habit_json[:errors] = habit.errors.full_messages

      json HabitPresenter.new(object: habit_json, type: 'habit').present_errors
    end
  end

  get '/api/habits' do
    habits = Habit.order(:id).page(page_number).per(page_size)
    presented_json = { meta: {}, data: [], links: {} }

    if params[:from].present? && params[:to].present?
      habits = habits.filter_by_dates(Time.parse(params[:from]), Time.parse(params[:to]))
    end
    habits.map do |habit|
      user = if params[:include] == 'user'
               user_habit = UserHabit.find_by(habit_id: habit.id)
               user_habit&.user ? user_habit.user : nil
             end
      presented_json[:data] << if user
                                 HabitPresenter.new(
                                   object: habit,
                                   type: 'habit',
                                   relationship_obj: user,
                                   relationship_type: 'user_habit'
                                 ).build_user_json
                               else
                                 HabitPresenter.new(
                                   object: habit,
                                   type: 'habit',
                                   obj_collection: habits
                                 ).build_user_json
                               end
    end

    json HabitPresenter.new(
      obj_collection: habits,
      links_metadata: links_metadata(habits),
      users_json: presented_json.as_json
    ).present_users
  end

  get '/api/habits/:id' do
    habit = Habit.find(params[:id])
    if habit
      user = UserHabit.find_by(habit_id: habit.id).user
      json HabitPresenter.new(
        object: habit,
        type: 'habit',
        relationship_obj: user,
        relationship_type: 'user'
      ).present_user
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
        user = UserHabit.find_by(habit_id: habit.id).user
        json HabitPresenter.new(
          object: habit,
          type: 'habit',
          relationship_obj: user,
          relationship_type: 'user'
        ).present_user
      else
        status(422)
        habit_json = habit.as_json
        habit_json[:errors] = habit.errors.full_messages

        json HabitPresenter.new(object: habit_json, type: 'habit')
      end
    else
      status(404)
    end
  end

  post '/api/habits/:id/missed' do
    habit = Habit.find(params[:id])
    if habit

      if habit.mark_incomplete!
        user = UserHabit.find_by(habit_id: habit.id).user
        json HabitPresenter.new(
          object: habit,
          type: 'habit',
          relationship_obj: user,
          relationship_type: 'user'
        ).present_user
      else
        status(422)
        habit_json = habit.as_json
        habit_json[:errors] = habit.errors.full_messages

        json HabitPresenter.new(object: habit_json, type: 'habit')
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
      json HabitPresenter.new(
        object: habit,
        type: 'habit',
        relationship_obj: user,
        relationship_type: 'user'
      ).present_user
    else
      status(422)
      habit_json = habit.as_json
      habit_json[:errors] = habit.errors.full_messages

      json HabitPresenter.new(object: habit_json, type: 'habit')
    end
  end

  private

  def json_req_body_attrs
    json_request_body[:data][:attributes]
  end

  def links_metadata(resource)
    {
      self: request.url,
      first: first_page_url,
      prev: prev_page_url,
      next: next_page_url,
      last: last_page_url(resource)
    }.as_json
  end

  def first_page_url
    new_page = Habit.page(1).current_page
    build_query_string(new_page)
  end

  def prev_page_url
    new_page = Habit.page(page_number).per(page_size).prev_page
    build_query_string(new_page)
  end

  def next_page_url
    new_page = Habit.page(page_number).per(page_size).next_page
    build_query_string(new_page)
  end

  def last_page_url(obj)
    new_page = Habit.page(obj.total_pages).current_page
    build_query_string(new_page)
  end

  def build_query_string(new_page)
    current_page_number = request.params['page']['number']
    query_string = request.query_string.gsub("page[number]=#{current_page_number}", "page[number]=#{new_page}")
    "#{request.base_url}#{request.path}?#{query_string}"
  end

  def page_number
    params[:page] && params[:page][:number] ? params[:page][:number] : DEFAULT_PAGE_NUMBER
  end

  def page_size
    params[:page] && params[:page][:size] ? params[:page][:size] : DEFAULT_PAGE_SIZE
  end
end
