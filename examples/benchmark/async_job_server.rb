#!/usr/bin/env async-service
# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024-2025, by Samuel Williams.
# Copyright, 2025, by Shopify Inc.

require_relative "config/environment"
require "async/job/adapter/active_job/environment"

service "async-job-server" do
	include Async::Job::Adapter::ActiveJob::Environment
	
	count 1
end
