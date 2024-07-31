#!/usr/bin/env ruby
# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

system("sidekiq", "-r", "./benchmark_job.rb")
