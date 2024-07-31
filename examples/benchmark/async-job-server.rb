#!/usr/bin/env async-service
# frozen_string_literal: true

require 'async/job/adapter/active_job/service'

service "job-server" do
	include Async::Job::Adapter::ActiveJob::Service
end
