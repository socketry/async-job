# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

require 'async'
require 'async/redis'
require_relative '../../lib/async/job'
require_relative 'example_job'

require 'securerandom'

Sync do
	client = Async::Redis::Client.new
	server = Async::Job::Backend::Redis::Server.new(ExampleJob, client, prefix: "async:job")
	
	server.start
end
