# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024-2025, by Samuel Williams.
# Copyright, 2025, by Shopify Inc.

source "https://rubygems.org"

gemspec

gem "agent-context"
gem "activejob", ">= 7.1"

group :maintenance, optional: true do
	gem "bake-gem"
	gem "bake-modernize"
	gem "bake-releases"
	
	gem "utopia-project"
end

group :test do
	gem "sus"
	gem "covered"
	gem "decode"

	gem "rubocop"
	gem "rubocop-socketry"
	
	gem "sus-fixtures-async"
	gem "sus-fixtures-console"
	
	gem "bake-test"
	gem "bake-test-external"
end
