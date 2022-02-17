# frozen_string_literal: true

require "simplecov"

SimpleCov.minimum_coverage 90

SimpleCov.profiles.define "custom_profile" do
  add_filter "/config/"
  add_filter "/spec/"

  add_group "Services", "app/services"
  add_group "Jobs", "app/jobs"
end
