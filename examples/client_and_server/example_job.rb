# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Alexey Ivanov.
# Copyright, 2024-2025, by Samuel Williams.
# Copyright, 2025, by Shopify Inc.

require_relative "base_job"

class ExampleJob < BaseJob
	def perform(message:)
		puts message
	end
end
