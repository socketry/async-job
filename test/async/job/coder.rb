
require 'async/job/coder'
require 'async/job/coder/message_pack'
require 'async/job/coder/json'
require 'async/job/coder/marshal'

ACoder = Sus::Shared("a coder") do |object|
	let(:coder) {subject.new}
	
	it "can round-trip objects" do
		data = coder.dump(object)
		expect(data).to be_a String
		
		expect(coder.load(data)).to be == object
	end
end

describe Async::Job::Coder::MessagePack do
	it_behaves_like ACoder, {items: [1, 2, 3]}
end

describe Async::Job::Coder::JSON do
	it_behaves_like ACoder, {items: [1, 2, 3]}
end

describe Async::Job::Coder::Marshal do
	it_behaves_like ACoder, {items: [1, 2, 3]}
end
