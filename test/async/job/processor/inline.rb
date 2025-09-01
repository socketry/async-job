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
		
		expect(delegate.called).to be == true
		expect(delegate.job).to be == job
	end
	
	it "handles scheduled jobs" do	
		scheduled_time = Time.now + 0.05
		job = {"scheduled_at" => scheduled_time}
		
		start_time = Time.now
		processor.call(job).wait
		
		expect(delegate.called).to be == true
	end
	
	it "handles errors in job processing" do
		error_delegate = ErrorDelegate.new
		
		error_processor = subject.new(error_delegate)
		job = {id: 1, data: "test"}
		
		# Should not raise exception
		expect{error_processor.call(job)}.not.to raise_exception
		
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
	
	with "#status_string" do
		it "returns status string with call and complete counts" do
			expect(processor.status_string).to be == "C=0/0 F=0"
			
			# Call the processor to increment counts
			job = {id: 1, data: "test"}
			processor.call(job)
			
			expect(processor.status_string).to be == "C=0/1 F=0"
		end
	end
end
