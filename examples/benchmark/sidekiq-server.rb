#!/usr/bin/env ruby

system("sidekiq", "-r", "./benchmark_job.rb")
