# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024-2025, by Samuel Williams.
# Copyright, 2024, by Alexey Ivanov.

require "async"
require "async/redis"
require "async/job"
require_relative "example_job"

require "securerandom"

Sync do
	client = Async::Redis::Client.new
	server = Async::Job::Queue::Redis::Server.new(nil, client, prefix: "async:job")
	
	5.times do
		job = ExampleJob.new(SecureRandom.uuid, scheduled_at: Time.now, message: "Hello, World! #{SecureRandom.uuid}")
		Console.info(server, "Enqueuing job: #{job.id} #{job.inspect}")
		server.call(job)
	end
	
	5.times do
		job = ExampleJob.new(SecureRandom.uuid, scheduled_at: nil, message: "Hello, World! #{SecureRandom.uuid}")
		Console.info(server, "Enqueuing job: #{job.id} #{job.inspect}")
		server.call(job)
	end
end
