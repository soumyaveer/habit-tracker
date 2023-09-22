class UsersController < ApplicationController
   get "/api/users" do
     users = User.all
     users_json = { data: []}
     users.each { |user| users_json[:data] << (Presenter.new(user, 'User').present_resource)}
     json users_json.as_json
   end

   post "/api/users" do
      user = User.new(
        name: json_request_body[:name],
        email: json_request_body[:email],
        password: json_request_body[:password],
      )
     
      if user.save
        json present(user).as_json
      else
        status(422)
        user_json = user.as_json
        user_json[:errors] = user.errors.full_messages
      
        json Presenter.new(user_json, 'User').present_errors.as_json
      end
   end

   patch '/api/users/:id' do
    user = User.find(params[:id])
    user.email = json_req_body_attrs[:email] if json_req_body_attrs[:email] 
    user.name = json_req_body_attrs[:name] if json_req_body_attrs[:name]
    user.password = json_req_body_attrs[:passowrd]  if json_req_body_attrs[:password] 
    
    if user.save
      json present(user).as_json
    else
      status(422)
      user_json = user.as_json
      user_json[:errors] = user.errors.full_messages

      json Presenter.new(user_json, 'User').present_errors.as_json
    end
  end

  delete '/api/users/:id' do
    user = User.find(params[:id])

    if user
      user.destroy!
      status 204
    else
      status 404
    end
  end

  get '/api/users/:id' do
    user = User.find(params[:id])

    if user 
      json present(user).as_json
    else
      status 404
    end
  end

  def json_req_body_attrs
    json_request_body[:data][:attributes]
  end

  def present(user)
    user_resp = {}
    user_resp[:data] = Presenter.new(user, 'User').present_resource
    user_resp
  end
end
