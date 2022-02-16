# frozen_string_literal: true

require File.expand_path("config/application", __dir__)

require "rake"

# rubocop
require "rubocop/rake_task"
RuboCop::RakeTask.new(:rubocop)

# load custom tasks
Rake.add_rakelib "lib/tasks"

task :environment do
  ENV["RACK_ENV"] ||= "development"
end

task(:lint).clear.enhance(%i[rubocop])
task(:default).clear.enhance(%i[lint])
