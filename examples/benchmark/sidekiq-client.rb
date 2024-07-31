#!/usr/bin/env ruby
# frozen_string_literal: true

require 'rails'
require 'active_job/railtie'
ActiveJob::Base.queue_adapter = :sidekiq

require_relative 'benchmark_job'

start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)

10_000.times do
	BenchmarkJob.perform_later
end

end_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
puts "Started at: #{start_time}"
puts "Ended at: #{end_time}"
puts "Total time: #{end_time - start_time}"
