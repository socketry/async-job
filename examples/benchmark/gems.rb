# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

source "https://rubygems.org"

gem "rails"

gem "sidekiq"

gem "async-job", path: "../../"
gem "async-job-adapter-active_job", path: "../../../async-job-adapter-active_job"
gem "async-service"
