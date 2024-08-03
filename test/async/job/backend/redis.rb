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
	let(:server) {Async::Job::Backend::Redis::Server.new(buffer, client, prefix:, resolution: 1)}
	
	before do
		@server_task = Async(transient: true) do
			server.start
		end
	end
	
	let(:job) {{"data" => "test job"}}
	
	it "can schedule a job and have it processed immediately" do
		server.call(job)
		
		expect(buffer.pop).to be == job
	end
	
	with "delayed job" do
		it "can schedule a job and have it processed after a delay" do
			now = Time.now
			delayed_job = job.merge(scheduled_at: now + 1)
			
			server.call(delayed_job)
			
			expect(buffer.pop).to have_keys(
				"data" => be == job["data"],
			)
		end
	end
end
