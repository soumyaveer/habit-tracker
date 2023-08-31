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
end
