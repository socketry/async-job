# frozen_string_literal: true

require_relative "lib/async/job/version"

Gem::Specification.new do |spec|
	spec.name = "async-job"
	spec.version = Async::Job::VERSION
	
	spec.summary = "An asynchronous job queue for Ruby."
	spec.authors = ["Samuel Williams", "Alexey Ivanov"]
	spec.license = "MIT"
	
	spec.cert_chain  = ["release.cert"]
	spec.signing_key = File.expand_path("~/.gem/release.pem")
	
	spec.metadata = {
		"documentation_uri" => "https://socketry.github.io/async-job/",
		"source_code_uri" => "https://github.com/socketry/async-job",
	}
	
	spec.files = Dir["{lib}/**/*", "*.md", base: __dir__]
	
	spec.required_ruby_version = ">= 3.2"
	
	spec.add_dependency "async", "~> 2.9"
end
