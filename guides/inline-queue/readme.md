# Inline Queue

This guide explains how to use the Inline queue to execute background jobs.

## Overview

The {ruby Async::Job::Queue::Inline} queue is designed to process jobs in the background using the `Async` framework. This is particularly useful when you want to execute jobs in the same process as the client, but in a separate task. The inline queue is ideal for low-latency jobs that do not require transactional consistency.

## Usage

You can use the inline quee for dequeueing and executing jobs:

~~~ ruby
pipeline = Async::Job::Builder.build(buffer) do
	dequeue Async::Job::Queue::Inline
end
~~~
