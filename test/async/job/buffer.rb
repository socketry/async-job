# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

require "async/job/buffer"
require "sus/fixtures/async/reactor_context"

describe Async::Job::Buffer do
	include Sus::Fixtures::Async::ReactorContext
	
	let(:buffer) {subject.new}
	
	with "no delegate" do
		it "can be initialized without a delegate" do
			expect(buffer).to be_a(Async::Job::Buffer)
		end
		
		it "starts with an empty queue" do
			expect(buffer).to be(:empty?)
		end
		
		it "can add jobs to the buffer" do
			job = {"data" => "test job"}
			buffer.call(job)
			
			expect(buffer).not.to be(:empty?)
			expect(buffer.pop).to be == job
		end
		
		it "can add multiple jobs" do
			job1 = {"id" => 1}
			job2 = {"id" => 2}
			
			buffer.call(job1)
			buffer.call(job2)
			
			expect(buffer.pop).to be == job1
			expect(buffer.pop).to be == job2
			expect(buffer).to be(:empty?)
		end
				
		it "can start without a delegate" do
			expect{buffer.start}.not.to raise_exception
		end
		
		it "can stop without a delegate" do
			expect{buffer.stop}.not.to raise_exception
		end
	end
	
	with "delegate" do
		let(:delegate) do
			Class.new do
				def initialize
					@jobs = []
					@started = false
					@stopped = false
				end
				
				attr_reader :jobs, :started, :stopped
				
				def call(job)
					@jobs << job
				end
				
				def start
					@started = true
				end
				
				def stop
					@stopped = true
				end
			end.new
		end
		
		let(:buffer) {subject.new(delegate)}
		
		it "can be initialized with a delegate" do
			expect(buffer).to be_a(Async::Job::Buffer)
		end
		
		it "delegates job calls to the delegate" do
			job = {"data" => "test job"}
			buffer.call(job)
			
			expect(delegate.jobs).to have_value(be == job)
		end
		
		it "starts the delegate when start is called" do
			buffer.start
			expect(delegate.started).to be == true
		end
		
		it "stops the delegate when stop is called" do
			buffer.stop
			expect(delegate.stopped).to be == true
		end
		
		it "still maintains its own queue" do
			job = {"data" => "test job"}
			buffer.call(job)
			
			expect(buffer.pop).to be == job
		end
	end
end 