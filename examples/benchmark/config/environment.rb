# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024-2025, by Samuel Williams.
# Copyright, 2025, by Shopify Inc.

require "rails"
require "active_job/railtie"
require "async/job/adapter/active_job/railtie"
require "async/job/processor/redis"

Async::Job::Adapter::ActiveJob::Railtie.define_queue "default" do
	# enqueue Async::Job::Processor::Aggregate
	dequeue Async::Job::Processor::Redis
end

require_relative "../benchmark_job"
