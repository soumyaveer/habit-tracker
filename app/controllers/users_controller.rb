class UsersController < ApplicationController
  get '/api/users' do
    users = User.all
    json users: users.as_json
  end
end
