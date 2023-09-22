# frozen_string_literal: true

source 'http://rubygems.org'
ruby '3.1.2'

gem 'activerecord'
gem 'bcrypt'
gem 'kaminari'
gem 'pg'
gem 'puma'
gem 'rake'
gem 'require_all'
gem 'rest-client'
gem 'sequel'
gem 'sinatra'
gem 'sinatra-activerecord', '~> 2.0', '>= 2.0.9'
gem 'sinatra-contrib', require: false

group :development, :test do
  gem 'database_cleaner', git: 'https://github.com/bmabey/database_cleaner.git'
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
  gem 'rack-test'
  gem 'rspec'
  gem 'rspec-core'
  gem 'simplecov'
  gem 'timecop', '~> 0.8.1'
  gem 'vcr', '~> 3.0', '>= 3.0.1'
end
