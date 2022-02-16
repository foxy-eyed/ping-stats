# frozen_string_literal: true

require "rubygems"
require "bundler/setup"

Bundler.require :default, ENV["RACK_ENV"]

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "..", "app"))
$LOAD_PATH.unshift(File.dirname(__FILE__))

Dir[File.expand_path("../app/**/*.rb", __dir__)].each { |f| require f }
