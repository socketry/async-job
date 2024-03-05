require 'active_job'

class BenchmarkJob < ActiveJob::Base
	def perform
		sleep(0.001)
		puts "Performed at: #{Process.clock_gettime(Process::CLOCK_MONOTONIC)}"
	end
end
