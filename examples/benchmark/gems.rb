# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024-2025, by Samuel Williams.

source "https://rubygems.org"

gem "rails"
gem "bake"

gem "sidekiq"

# source "https://user:pass@enterprise.contribsys.com/" do
#   gem "sidekiq-ent", "~> 8.0"
#   gem "sidekiq-pro", "~> 8.0"
# end

gem "async-job", path: "../../"
gem "async-job-processor-redis"
gem "async-job-adapter-active_job"
gem "async-service"

# SolidQueue support
gem "solid_queue"
gem "sqlite3"
