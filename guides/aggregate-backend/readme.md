# Aggregate Queue

This guide explains how to use the Aggregate queue to reduce input latency and improve the performance of your application.

## Overview

The {ruby Async::Job::Queue::Aggregate} queue is designed to reduce front-end processing latency by accumulating multiple jobs which are then processed together. This is particularly useful when you are scheduling jobs during a request-response cycle, as it allows you to move processing latency to a background task. However, as a consequence, it may reduce the overall robustness of your application, as a failure during processing may result in jobs being lost. The aggregate queue tries to mitigate this risk by ensuring all pending jobs are processed before the application exits, but it is not guaranteed.

## Usage

You can add the aggregate queue to an existing queue:

~~~ ruby
pipeline = Async::Job::Builder.build(buffer) do
	# Aggregating before passing the job into Redis will avoid Redis latency issues affecting the front-end:
	queue Async::Job::Queue::Aggregate
	queue Async::Job::Queue::Redis
end
~~~
