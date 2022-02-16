# frozen_string_literal: true

require "rubygems"
require "bundler/setup"
require "dotenv"

Dotenv.load

Bundler.require :default, ENV["RACK_ENV"]

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "..", "app"))
$LOAD_PATH.unshift(File.dirname(__FILE__))

Dir[File.expand_path("../config/initializers/*.rb", __dir__)].each { |f| require f }
Dir[File.expand_path("../lib/**/*.rb", __dir__)].each { |f| require f }
Dir[File.expand_path("../app/**/*.rb", __dir__)].each { |f| require f }
