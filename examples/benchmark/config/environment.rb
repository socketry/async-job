# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

require 'rails'
require 'active_job/railtie'
require 'async/job/adapter/active_job/railtie'

Async::Job::Adapter::ActiveJob::Railtie.define_queue "default" do
	dequeue Async::Job::Queue::Redis
end

ActiveJob::Base.queue_adapter = Async::Job::Adapter::ActiveJob::Railtie.config.active_job.queue_adapter

require_relative '../benchmark_job'
