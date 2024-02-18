class TestJob < ActiveJob::Base
	queue_as :default
	
	def perform(*arguments, **options)
	end
end
