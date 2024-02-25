require 'json'

module Async
	module Job
		module Coder
			class JSON
				def initialize
				end
				
				def dump(job)
					::JSON.dump(job)
				end
				
				def load(data)
					::JSON.parse(data, symbolize_names: true)
				end
				
				DEFAULT = self.new
			end
		end
	end
end
