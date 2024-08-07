require 'async/job'
require 'async/job/backend/aggregate'
require 'async/job/buffer'

jobs = 10

Async do
	buffer = Async::Job::Buffer.new # where to put the jobs when dequeued
	redis = Async::Job::Backend::Redis.new(buffer)
	server = Async::Job::Backend::Aggregate.new(redis)
	
	# 100 requests / web server
	jobs.times do |i|
		server.call({job: Object, args: [i]})
	end
end
