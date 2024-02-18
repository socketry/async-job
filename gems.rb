# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

source "https://rubygems.org"

gemspec

gem "activejob", ">= 7.1"

group :test do
	gem "sus"
	gem "covered"
	
	gem 'sus-fixtures-async'
	
	gem "bake-test"
	gem "bake-test-external"
end

group :maintenance, optional: true do
	gem "bake-gem"
	gem "bake-modernize"
	
	gem "utopia-project"
end
