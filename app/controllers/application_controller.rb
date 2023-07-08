# frozen_string_literal: true
require "./config/environment"

class ApplicationController < Sinatra::Base
  configure do
    enable :sessions
    set :session_secret, "secret"
    use Rack::CommonLogger, STDOUT
  end

  configure :development do
    require "sinatra/reloader"
    register Sinatra::Reloader
  end

  def json_request_body
    @json_request_body ||= JSON.parse(request.body.read).with_indifferent_access
  end
end
