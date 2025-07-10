# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024-2025, by Samuel Williams.
# Copyright, 2025, by Shopify Inc.

require "async/job/processor/aggregate"
require "sus/fixtures/async/reactor_context"
require "sus/fixtures/console/captured_logger"

class Delegate
	attr_reader :called_jobs, :started, :stopped
	def initialize
		@called_jobs = []
		@started = false
		@stopped = false
	end
	def call(job)
		@called_jobs << job
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

describe Async::Job::Processor::Aggregate do
	include Sus::Fixtures::Async::ReactorContext
	include_context Sus::Fixtures::Console::CapturedLogger

	let(:delegate) {Delegate.new}

	let(:processor) {subject.new(delegate)}

	it "processes jobs in batches" do
		processor.call(:job1)
		processor.call(:job2)
		
		# Give the processor a chance to process jobs
		sleep(0.1)
		
		expect(delegate.called_jobs).to be(:include?, :job1)
		expect(delegate.called_jobs).to be(:include?, :job2)
	end

	it "handles errors in flush" do
		error_delegate = ErrorDelegate.new
		
		error_processor = subject.new(error_delegate)
		error_processor.call(:job1)
		# Give the processor a chance to process jobs and handle error
		sleep(0.1)
		
		# Assert that the error was logged
		expect_console.to have_logged(
			severity: be == :error,
			message: be(:include?, "Could not flush")
		)
	end

	it "delegates start to super and start!" do
		# This will call super (Generic#start) and then start!
		# We can't easily check super, but we can check that start! returns true
		result = processor.send(:start!)
		expect(result).to be == true
	end

	it "delegates start to delegate" do
		result = processor.start
		expect(delegate.started).to be == true
		expect(result).to be == true
	end

	it "delegates stop to delegate" do
		result = processor.stop
		expect(delegate.stopped).to be == true
		expect(result).to be == "stopped"
	end
end
