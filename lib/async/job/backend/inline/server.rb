# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

require_relative '../../coder'

require 'async/idler'

module Async
	module Job
		module Backend
			module Inline
				class Server
					def initialize(delegate, parent: nil)
						@delegate = delegate
						@parent = parent || Async::Idler.new
					end
					
					def call(job)
						scheduled_at = Coder::Time(job["scheduled_at"])
						
						@parent.async do
							if scheduled_at
								sleep(scheduled_at - Time.now)
							end
							
							@delegate.call(job)
						rescue => error
							Console.error(self, error)
						end
					end
				end
			end
		end
	end
end
