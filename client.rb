# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

require 'async'
require 'async/redis'
require_relative 'lib/async/job'

require 'securerandom'

Job = Struct.new(:id, :perform_at, :serialize)

Async do
	client = Async::Redis::Client.new
	server = Async::Job::Backend::Redis::Server.new(client, "async:job")
	
	10.times do
		job = Job.new(SecureRandom.uuid, Time.now.to_f, "Hello, World!")
		Console.info(server, "Enqueuing job: #{job.id} #{job.inspect}")
		server.enqueue(job)
	end
end
