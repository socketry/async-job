# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.
# Copyright, 2025, by Shopify Inc.

module Async
	module Job
		# Represents a job queue that manages the client and server components of a job processing system.
		# The queue acts as a facade that provides a unified interface for both enqueueing jobs
		# and managing the processing server lifecycle.
		class Queue
			# Initialize a new job queue.
			# @parameter client [Object] The client component for enqueueing jobs.
			# @parameter server [Object] The server component for processing jobs.
			# @parameter delegate [Object] The delegate that will execute the jobs.
			def initialize(client, server, delegate)
				@client = client
				@server = server
				@delegate = delegate
			end
			
			# @attribute [Object] The client component for enqueueing jobs.
			attr :client
			
			# @attribute [Object] The server component for processing jobs.
			attr :server
			
			# @attribute [Object] The delegate that will execute the jobs.
			attr :delegate
			
			# Enqueue a job using the client component.
			def call(...)
				@client.call(...)
			end
			
			# Start the job processing server.
			def start
				@server.start
			end
			
			# Stop the job processing server.
			def stop
				@server.stop
			end
		end
	end
end
