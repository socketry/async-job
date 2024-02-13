# frozen_string_literal: true

require_relative "lib/async/job/version"

Gem::Specification.new do |spec|
	spec.name = "async-job"
	spec.version = Async::Job::VERSION
	
	spec.summary = "A asynchronous job queue for Ruby."
	spec.authors = ["Samuel Williams"]
	spec.license = "MIT"
	
	spec.cert_chain  = ['release.cert']
	spec.signing_key = File.expand_path('~/.gem/release.pem')
	
	spec.metadata = {
		"documentation_uri" => "https://socketry.github.io/async-job",
	}
	
	spec.files = Dir['{lib}/**/*', '*.md', base: __dir__]
	
	spec.required_ruby_version = ">= 3.0"
	
	spec.add_runtime_dependency "async", ">= 1.0"
	spec.add_runtime_dependency "async-redis"
end
