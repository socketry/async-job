# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

require 'async'
require 'async/redis'

require 'sus/fixtures/async/reactor_context'

require 'async/job/buffer'
require 'async/job/backend/aggregate'

describe Async::Job::Backend::Aggregate do
	include Sus::Fixtures::Async::ReactorContext
	
	let(:buffer) {Async::Job::Buffer.new}
	let(:server) {subject.new(buffer)}
	
	let(:job) {{"data" => "test job"}}
	
	it "can schedule a job" do
		server.call(job)
		
		expect(buffer.pop).to be == job
	end
end
