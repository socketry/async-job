#!/usr/bin/env async-service
# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

require "async/job/adapter/active_job/service"

service "job-server" do
	include Async::Job::Adapter::ActiveJob::Service
end
