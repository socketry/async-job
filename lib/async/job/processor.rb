# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024-2025, by Samuel Williams.
# Copyright, 2025, by Shopify Inc.

require_relative "processor/inline"

module Async
	module Job
		# Represents a collection of job processors that handle the execution of jobs.
		# Provides different processing strategies including inline, aggregate, delayed, and generic processors.
		module Processor
			# Create a new processor instance with the specified type and options.
			# @option processor [Class] The processor class to instantiate (defaults to Inline).
			# @option **options [Hash] Additional options to pass to the processor constructor.
			# @returns [Object] A new processor instance.
			def self.new(processor: Inline, **options)
				processor.new(**options)
			end
		end
	end
end
