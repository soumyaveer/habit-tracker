class UsersController < ApplicationController
   get "/api/users" do
     users = User.all
     json users: users.as_json
   end

   post "/api/users" do
      user = User.new(
        name: json_request_body[:name],
        email: json_request_body[:email],
        password: json_request_body[:password],
      )

      if user.save
        json user.as_json
      else
        status(422)
        user_json = user.as_json
        user_json[:errors] = user.errors.full_messages

        json user_json
      end
   end

   patch '/api/users/:id' do
    user = User.find(params[:id])
    user.email = json_req_body_attrs[:email] if json_req_body_attrs[:email] 
    user.name = json_req_body_attrs[:name] if json_req_body_attrs[:name]
    user.password = json_req_body_attrs[:passowrd]  if json_req_body_attrs[:password] 
    
    if user.save
      json present_resource(user, "user")
    else
      status(422)
      user_json = user.as_json
      user_json[:errors] = user.errors.full_messages

      json present_errors(user_json, 'user') 
    end
  end

  def json_req_body_attrs
    json_request_body[:data][:attributes]
  end
end
