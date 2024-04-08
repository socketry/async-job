# Getting Started

This guide gives you an overview of the `async-job` gem and explains the core concepts.

## Installation

Add the gem to your project:

``` shell
$ bundle add async-job
```

## Core Concepts

`async-job` is a library for building asynchronous job queues.

- Several included {ruby Async::Job::Backend} implementations for enqueueing and running jobs.
- Several supported {ruby Async::Job::Coder} implementations for encoding and decoding job payloads.
- A {ruby Async::Job::Generic} class which describes the minimum required job interface.

The `async-job` library provides a framework for enqueueing and dequeuing jobs, without prescribing how jobs are executed. It is expected that you would use this library to wrap existing schemas for job definition and execution. This design allows you to use `async-job` in a wide variety of applications, without the need for cumbersome wrappers.

## Usage

In general, a job processing system comprises two parts: a job producer and a job consumer. The producer enqueues jobs, and the consumer dequeues and processes them.

```mermaid
sequenceDiagram
	participant A as Application
	participant ME as Middleware (Enqueue)
	participant S as Server (Queue)
	participant MD as Middleware (Dequeue)
	participant H as Handler 

	Note over A,S: Producer
	A->>+ME: Submit Job
	ME->>+S: Enqueue Job

	Note over S,H: Consumer
	S->>+MD: Dequeue Job
	MD->>+H: Execute Job
```

You can use {ruby Async::Job::Builder} to create a pipeline that includes both the producer and consumer sides of a queue:

```ruby
require 'async/job'
require 'async/job/backend/inline'

# This is how we execute a job from the queue:
executor = proc do |job|
	puts "Processing job: #{job}"
end

# Create a simple inline pipeline:
pipeline = Async::Job::Builder.build(executor) do
	# We are going to use an inline queue which processes the job in the background using Async{}:
	queue Async::Job::Backend::Inline
end

# Enqueue a job:
Async do
	pipeline.producer.call("My job")
	# Prints "Processing job: My job"
end
```

There are two queues included with the library: {ruby Async::Job::Backend::Inline} and {ruby Async::Job::Backend::Redis}. The inline queue is useful for testing and adjacent non-critical job execution, while the Redis queue is useful for robust and distributed job execution.
