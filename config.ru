require "./config/environment"
require "sinatra/json"

use Rack::MethodOverride

run ApplicationController