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
						perform_at = job[:perform_at]
						
						Async do
							if perform_at
								sleep(perform_at - Time.now)
							end
							
							@handler.call(job)
						end
					end
				end
			end
		end
	end
end
