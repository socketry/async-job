# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

require "async/job/processor/generic"

describe Async::Job::Processor::Generic do
	let(:delegate) do
		Class.new do
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
		end.new
	end

	let(:processor) {subject.new(delegate)}

	it "delegates call to delegate" do
		job = {id: 1, data: "test"}
		result = processor.call(job)
		expect(delegate.called).to be == true
		expect(delegate.job).to be == job
		expect(result).to be == "result"
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