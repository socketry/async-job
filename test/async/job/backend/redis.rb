# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

require 'async'
require 'async/redis'

require 'sus/fixtures/async/reactor_context'

require 'async/job/buffer'
require 'async/job/backend/redis'

describe Async::Job::Backend::Redis do
	include Sus::Fixtures::Async::ReactorContext
	
	let(:buffer) {Async::Job::Buffer.new}
	
	let(:client) {Async::Redis::Client.new}
	let(:prefix) {"async:job:#{SecureRandom.hex(8)}"}
	let(:server) {Async::Job::Backend::Redis::Server.new(buffer, client, prefix:)}
	
	def before
		super
		
		@server_task = Async do
			server.start
		end
	end
	
	let(:job) {{data: "test job"}}
	
	it "can schedule a job" do
		server.enqueue(job)
		
		expect(buffer.pop).to be == job
	end
end
