# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

module Async
	module Job
		module Backend
			module Inline
				class Server
					def initialize(handler)
						@handler = handler
					end
					
					def enqueue(job)
						Async do
							@handler.call(job)
						end
					end
					
					def schedule(job, timestamp)
						Async do
							sleep(timestamp - Time.now)
							@handler.call(job)
						end
					end
				end
			end
		end
	end
end
