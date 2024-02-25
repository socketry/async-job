require 'msgpack'

module Async
	module Job
		module Coder
			class MessagePack
				def initialize
					@factory = ::MessagePack::Factory.new
					
					@factory.register_type(0x01, Symbol)
					
					@factory.register_type(0x02, Time,
						packer: ::MessagePack::Time::Packer,
						unpacker: ::MessagePack::Time::Unpacker
					)
				end
				
				def dump(job)
					@factory.pack(job)
				end
				
				def load(data)
					@factory.unpack(data)
				end
				
				DEFAULT = self.new
			end
		end
	end
end
