# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

require 'async'
require 'async/redis'
require_relative 'lib/async/job'

require 'securerandom'

Job = Struct.new(:id, :scheduled_at, :serialize)

Async do
	client = Async::Redis::Client.new
	server = Async::Job::Backend::Redis::Server.new(client, "async:job")
	
	server_task = Async do
		server.start
		
		server.each do |id, job|
			Console.info(server, "Processing job: #{id} #{job.inspect}")
			sleep(1)
		end
	end
end
