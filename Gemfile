source "http://rubygems.org"
ruby "3.1.2"

gem 'activerecord'
gem "bcrypt"
gem 'pg'
gem 'puma'
gem 'rake'
gem 'require_all'
gem 'rest-client'
gem 'sinatra'
gem 'sinatra-contrib', require: false
gem 'sinatra-activerecord', '~> 2.0', '>= 2.0.9'
gem 'sequel'
gem 'kaminari'

group :development, :test do
  gem "database_cleaner", git: "https://github.com/bmabey/database_cleaner.git"
  gem 'faker'
end

group :development do
  gem 'foreman'
  gem 'interactor'
  gem 'pry'
  gem 'rubocop'
  gem 'tux'
end

group :test do
  gem 'rspec'
  gem 'rspec-core'
  gem "rack-test"
  gem "simplecov"
  gem 'timecop', '~> 0.8.1'
  gem 'vcr', '~> 3.0', '>= 3.0.1'
end


