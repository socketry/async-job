# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Alexey Ivanov.

class BaseJob
	def initialize(id, *args, scheduled_at: nil, **kwargs)
		@id = id
		@scheduled_at = scheduled_at
		@args = args
		@kwargs = kwargs
	end
	
	attr :id
	attr :scheduled_at
	
	def [](key)
		return @id if key == 'id'
		return @scheduled_at if key == 'scheduled_at'
	end
	
	def to_json(*args)
		{
			id: @id,
			args: @args,
			kwargs: @kwargs
		}.to_json
	end
	
	def perform(*args, **kwargs)
		raise NotImplementedError
	end
	
	def self.call(hash)
		kwargs = hash['kwargs'].each_with_object({}) do |(k, v), memo|
			memo[k.to_sym] = v
		end
		
		self.new(hash['id']).perform(*hash['args'], **kwargs)
	end
end
