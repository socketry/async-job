source "https://rubygems.org"

gem "rails"

gem "sidekiq"

gem "async-job", path: "../../"
gem "async-job-adapter-active_job", path: "../../../async-job-adapter-active_job"
gem "async-service"
