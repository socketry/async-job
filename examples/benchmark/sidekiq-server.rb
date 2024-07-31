#!/usr/bin/env ruby
# frozen_string_literal: true

system("sidekiq", "-r", "./benchmark_job.rb")
