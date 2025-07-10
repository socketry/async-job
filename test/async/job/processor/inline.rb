# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024-2025, by Samuel Williams.
# Copyright, 2025, by Shopify Inc.

require "async/job/processor/inline"
require "sus/fixtures/async/reactor_context"
require "sus/fixtures/console/captured_logger"

class Delegate
	attr_reader :called, :started, :stopped, :job
	def initialize
		@called = false
		@started = false
		@stopped = false
		@job = nil
	end
	def call(job)
		@called = true
		@job = job
		"result"
	end
	def start
		@started = true
		"started"
	end
	def stop
		@stopped = true
		"stopped"
	end
end

class ErrorDelegate
	def call(job)
		raise "Test error"
	end
end

describe Async::Job::Processor::Inline do
	include Sus::Fixtures::Async::ReactorContext
	include_context Sus::Fixtures::Console::CapturedLogger
	
	let(:delegate) {Delegate.new}

	let(:processor) {subject.new(delegate)}

	it "processes jobs asynchronously" do
		job = {id: 1, data: "test"}
		processor.call(job)
		
		# Wait a bit for async processing
		sleep(0.1)
		
		expect(delegate.called).to be == true
		expect(delegate.job).to be == job
	end

	it "handles scheduled jobs" do
		scheduled_time = Time.now + 0.05
		job = {id: 1, scheduled_at: scheduled_time}
		
		start_time = Time.now
		processor.call(job)
		
		# Wait for processing to complete
		sleep(0.1)
		
		expect(delegate.called).to be == true
		# The job should have been delayed by at least 0.05 seconds
		expect(Time.now - start_time).to be >= 0.05
	end

	it "calls sleep for scheduled jobs" do
		scheduled_time = Time.now + 0.1
		job = {id: 1, "scheduled_at" => scheduled_time}
		
		# Mock the sleep method to ensure it's called
		expect(processor).to receive(:sleep).and_return(nil)
		
		processor.call(job).wait
		
		expect(delegate.called).to be == true
	end

	it "handles errors in job processing" do
		error_delegate = ErrorDelegate.new
		
		error_processor = subject.new(error_delegate)
		job = {id: 1, data: "test"}
		
		# Should not raise exception
		expect{error_processor.call(job)}.not.to raise_exception
		
		# Wait for async processing
		sleep(0.1)
		
		# Assert that the error was logged
		expect_console.to have_logged(
			severity: be == :error,
			message: be(:include?, "Test error")
		)
	end

	it "delegates start to delegate" do
		result = processor.start
		expect(delegate.started).to be == true
		expect(result).to be == "started"
	end

	it "delegates stop to delegate" do
		result = processor.stop
		expect(delegate.stopped).to be == true
		expect(result).to be == "stopped"
	end
end
