require 'msgpack'

module Async
	module Job
		module Coder
			class Marshal
				def dump(job)
					::Marshal.dump(job)
				end
				
				def load(data)
					::Marshal.load(data)
				end
				
				DEFAULT = self.new
			end
		end
	end
end
