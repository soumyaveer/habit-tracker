require "./config/environment"
require "sinatra/json"

use Rack::MethodOverride

# TODO: Add controllers here
# use ControllerName
run ApplicationController