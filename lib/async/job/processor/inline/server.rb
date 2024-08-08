# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

require_relative '../../coder'
require_relative '../generic'

require 'async/idler'

module Async
	module Job
		module Processor
			module Inline
				class Server < Generic
					def initialize(delegate, parent: nil)
						super(delegate)
						
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
					
					def start
						@delegate&.start
					end
					
					def stop
						@delegate&.stop
					end
				end
			end
		end
	end
end
