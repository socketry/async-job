require 'async'
require 'async/redis'
require 'active_job'

require 'sus/fixtures/async/reactor_context'

require 'async/job/backend/redis/server'
require 'async/job/adapter/active_job'
require 'test_job'

describe Async::Job::Adapter::ActiveJob do
	include Sus::Fixtures::Async::ReactorContext
	
	let(:client) {Async::Redis::Client.new}
	let(:prefix) {"async:job:#{SecureRandom.hex(8)}"}
	let(:server) {Async::Job::Backend::Redis::Server.new(client, prefix)}
	
	def before
		super
		
		@server_task = Async do
			server.start
		end
	end
	
	it "can schedule a job" do
		ActiveJob::Base.queue_adapter = subject.new(server)
		
		job = TestJob.perform_later
		
		server.process do |id, job|
			pp job
		end
	end
end