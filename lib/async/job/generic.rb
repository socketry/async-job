# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

module Async
	module Job
		class Generic
			def self.enqueue(...)
				self.new(...).enqueue
			end
			
			def initialize(id, perform_at: nil)
				@id = id
				@perform_at = perform_at
			end
			
			attr :id
			attr :perform_at
			
			def serialize
				raise NotImplementedError
			end
			
			def call
				raise NotImplementedError
			end
		end
	end
end
