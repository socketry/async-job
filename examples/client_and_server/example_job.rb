# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

require_relative 'base_job'

class ExampleJob < BaseJob
  def perform(message:)
    puts message
  end
end
