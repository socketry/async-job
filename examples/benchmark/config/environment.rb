# frozen_string_literal: true

require 'rails'
require 'active_job/railtie'
require 'async/job/adapter/active_job/railtie'

Async::Job::Adapter::ActiveJob::Railtie.backend_for "default" do
	queue Async::Job::Backend::Redis
end

ActiveJob::Base.queue_adapter = Async::Job::Adapter::ActiveJob::Railtie.config.active_job.queue_adapter

require_relative '../benchmark_job'
