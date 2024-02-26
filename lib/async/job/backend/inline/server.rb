# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

require_relative '../../coder'

module Async
	module Job
		module Backend
			module Inline
				class Server
					def initialize(handler)
						@handler = handler
					end
					
					def enqueue(job)
						scheduled_at = Coder::Time(job[:scheduled_at])
						
						Async do
							if scheduled_at
								sleep(scheduled_at - Time.now)
							end
							
							@handler.call(job)
						end
					end
				end
			end
		end
	end
end
