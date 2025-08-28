#!/usr/bin/env ruby
# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024-2025, by Samuel Williams.

require_relative "config/environment"

# Start sidekiq server with specific queue configuration
exec("sidekiq", "-q", "sidekiq_default", "-r", File.expand_path("config/environment.rb", __dir__))
