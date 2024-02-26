# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

require 'async/job/builder'
require 'async/job/backend/inline'
require 'async/job/buffer'

require 'sus/fixtures/async/reactor_context'

describe Async::Job::Builder do
	it "can build a simple inline pipeline" do
		buffer = Async::Job::Buffer.new
		
		# Create a simple inline pipeline:
		pipeline = Async::Job::Builder.build(buffer) do
			queue Async::Job::Backend::Inline
		end
		
		# Enqueue a job:
		pipeline.producer.call("My job")
		
		expect(buffer.pop).to be == "My job"
	end
end
