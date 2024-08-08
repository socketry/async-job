# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

require 'async'
require 'async/redis'

require 'sus/fixtures/async/reactor_context'

require 'async/job/buffer'
require 'async/job/backend/aggregate'

class SlowBackend
	def initialize(delegate = nil)
		@condition = Async::Condition.new
		@delegate = delegate
	end
	
	attr :condition
	
	def call(job)
		@condition.wait
		@delegate&.call(job)
	end
	
	def start
		@delegate&.start
	end
	
	def stop
		@delegate&.stop
	end
end

describe Async::Job::Backend::Aggregate do
	include Sus::Fixtures::Async::ReactorContext
	
	let(:buffer) {Async::Job::Buffer.new}
	let(:server) {subject.new(buffer)}
	
	let(:job) {{"data" => "test job"}}
	
	it "can schedule a job" do
		server.call(job)
		
		expect(buffer.pop).to be == job
	end
	
	with "slow backend" do
		let(:backend) {SlowBackend.new(buffer)}
		let(:server) {subject.new(backend)}
		
		it "flushes jobs on shutdown" do
			server.call(job)
			server.stop
			
			expect(buffer).to be(:empty?)
			
			# Allow job processing to continue:
			backend.condition.signal
			
			expect(buffer.pop).to be == job
		end
	end
end
