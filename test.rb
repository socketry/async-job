require 'async/job'
require 'async/job/backend/aggregate'
require 'async/job/buffer'

jobs = 1

Async do
	buffer = Async::Job::Buffer.new # where to put the jobs when dequeued
	redis = Async::Job::Backend::Redis.new(buffer)
	server = Async::Job::Backend::Aggregate.new(redis)
	
	jobs.times do
		server.call({job: Object, args: [123, "hello world", hash]})
	end
end
