# frozen_string_literal: true

ENV['RACK_ENV'] ||= 'development'

require_relative './config/environment'
require 'sinatra/activerecord/rake'

begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:spec) do |t|
    if ENV.key?('CI')
      t.rspec_opts = '-r rspec_junit_formatter --format RspecJunitFormatter -o test_results/test-rspec.xml'
    end
  end
rescue LoadError
end

desc 'open pry'
task :console do
  Pry.start
end
