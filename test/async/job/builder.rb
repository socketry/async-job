# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

require "async/job/builder"
require "async/job/processor/inline"
require "async/job/buffer"

require "sus/fixtures/async/reactor_context"

describe Async::Job::Builder do
	include Sus::Fixtures::Async::ReactorContext
	
	it "can build a simple inline pipeline" do
		buffer = Async::Job::Buffer.new
		
		# Create a simple inline pipeline:
		pipeline = Async::Job::Builder.build(buffer) do
			enqueue Async::Job::Processor::Inline
		end
		
		# Enqueue a job:
		pipeline.client.call("My job")
		
		expect(buffer.pop).to be == "My job"
	end
end
