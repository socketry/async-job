# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

require_relative "processor/inline"

module Async
	module Job
		module Processor
			def self.new(processor: Inline, **options)
				processor.new(**options)
			end
		end
	end
end
