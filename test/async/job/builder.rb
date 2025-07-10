# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024-2025, by Samuel Williams.
# Copyright, 2025, by Shopify Inc.

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

	it "can add dequeue middleware" do
		buffer = Async::Job::Buffer.new
		
		# Create a pipeline with dequeue middleware:
		pipeline = Async::Job::Builder.build(buffer) do
			dequeue Async::Job::Processor::Inline
		end
		
		# The dequeue middleware should be applied to the server side
		expect(pipeline.server).to be_a(Async::Job::Processor::Inline)
		expect(pipeline.client).to be_a(Async::Job::Processor::Inline)
		expect(pipeline.delegate).to be == buffer
	end

	it "can set delegate using delegate method" do
		custom_delegate = Object.new
		
		# Create a pipeline with custom delegate:
		pipeline = Async::Job::Builder.build do
			delegate custom_delegate
		end
		
		expect(pipeline.delegate).to be == custom_delegate
		expect(pipeline.client).to be == custom_delegate
		expect(pipeline.server).to be == custom_delegate
	end

	it "can build with both enqueue and dequeue middleware" do
		buffer = Async::Job::Buffer.new
		
		# Create a pipeline with both enqueue and dequeue middleware:
		pipeline = Async::Job::Builder.build(buffer) do
			enqueue Async::Job::Processor::Inline
			dequeue Async::Job::Processor::Inline
		end
		
		# Both client and server should be wrapped with Inline processors
		expect(pipeline.client).to be_a(Async::Job::Processor::Inline)
		expect(pipeline.server).to be_a(Async::Job::Processor::Inline)
		expect(pipeline.delegate).to be == buffer
	end

	it "can build with custom delegate parameter" do
		custom_delegate = Object.new
		
		# Create a pipeline with custom delegate passed to build:
		pipeline = Async::Job::Builder.build(custom_delegate) do
			enqueue Async::Job::Processor::Inline
		end
		
		expect(pipeline.delegate).to be == custom_delegate
		expect(pipeline.client).to be_a(Async::Job::Processor::Inline)
		expect(pipeline.server).to be == custom_delegate
	end

	it "can chain middleware methods" do
		buffer = Async::Job::Buffer.new
		
		# Test method chaining:
		builder = Async::Job::Builder.new(buffer)
		result = builder.enqueue(Async::Job::Processor::Inline)
			.dequeue(Async::Job::Processor::Inline)
			.delegate(buffer)
		
		expect(result).to be == builder
		
		# Build the pipeline:
		pipeline = builder.build
		expect(pipeline.delegate).to be == buffer
	end
end
