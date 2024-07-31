# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

require 'async'
require 'async/redis'
require 'async/job'
require_relative 'example_job'

require 'securerandom'

Async do
	client = Async::Redis::Client.new
	server = Async::Job::Backend::Redis::Server.new(nil, client, prefix: "async:job")

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
