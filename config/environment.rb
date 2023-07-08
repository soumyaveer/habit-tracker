ENV["RACK_ENV"] ||= "development"

require "bundler/setup"
Bundler.require(:default, ENV["RACK_ENV"])

require_all "app"

# Load Pry only in development env
require "pry" if defined?(Pry)

require "rack-flash"