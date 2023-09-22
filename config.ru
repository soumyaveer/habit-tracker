# frozen_string_literal: true

require './config/environment'
require 'sinatra/json'

use Rack::MethodOverride

# TODO: Add controllers here
# use ControllerName
use UsersController
use HabitsController

run ApplicationController
