# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024-2025, by Samuel Williams.
# Copyright, 2025, by Shopify Inc.

require "rails"
require "active_job/railtie"
require "async/job/adapter/active_job/railtie"
require "async/job/processor/aggregate"
require "async/job/processor/redis"

ActiveJob::Base.logger = Logger.new(nil)
PERFORMANCE_LOG = File.open("performance.log", "a")
PERFORMANCE_LOG.sync = true

# Define async-job queue for async-job adapter
Async::Job::Adapter::ActiveJob::Railtie.define_queue "default" do
	enqueue Async::Job::Processor::Aggregate
	dequeue Async::Job::Processor::Redis
end

require "sidekiq"

begin
	require "sidekiq-pro"
	require "sidekiq-ent"

	Sidekiq::Client.reliable_push!

	Sidekiq.configure_server do |config|
		config.super_fetch!
		config.reliable_scheduler!
	end
rescue LoadError
	# Ignore.
end

require_relative "../async_job_benchmark_job"
require_relative "../sidekiq_benchmark_job"
