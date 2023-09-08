# frozen_string_literal: true
require "./config/environment"

class ApplicationController < Sinatra::Base
  configure do
    enable :sessions
    set :session_secret, ENV.fetch('SESSION_SECRET') { SecureRandom.hex(64) }
    use Rack::CommonLogger, STDOUT
  end

  configure :development do
    require "sinatra/reloader"
    register Sinatra::Reloader
  end

  get "/" do
    erb :'/index'
  end

  def json_request_body
    @json_request_body ||= JSON.parse(request.body.read).with_indifferent_access
  end



  def present_errors(err, type)
    puts "I am here"
    {
      "data": 
        {
          "type": type,
          "attributes": {
            errors: err[:errors]
          }
        }
    }
  end

  def present_resource(obj, type)
    {
      "data": 
        {
          "type": obj.class,
          "id": obj.id,
          "attributes": obj

        }
      }.as_json
  end
end
