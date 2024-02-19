require 'async/service/generic'

module Async
	module Job
		module Service
			class ActiveJobServer < Async::Service::Generic
				def self.each
					yield :service_class, self
				end
				
				def setup(container)
					container.run(name: self.name, restart: true) do |instance|
						instance.ready!
						
						Sync do
							self.queue_adapter.start
						end
					end
				end
			end
		end
	end
end
