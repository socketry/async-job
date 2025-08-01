# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

source "https://rubygems.org"

gem "rails"

gem "sidekiq"

# source "https://enterprise.contribsys.com/" do
#   gem "sidekiq-ent", "~> 8.0"
#   gem "sidekiq-pro", "~> 8.0"
# end

gem "async-job", path: "../../"
gem "async-job-processor-redis"
gem "async-job-adapter-active_job"
gem "async-service"
