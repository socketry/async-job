# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

require "async/job/coder"
require "async/job/coder/message_pack"
require "async/job/coder/marshal"

ACoder = Sus::Shared("a coder") do |object|
	let(:coder) {subject.new}
	
	it "can round-trip objects" do
		data = coder.dump(object)
		expect(data).to be_a String
		
		expect(coder.load(data)).to be == object
	end
end

describe Async::Job::Coder::MessagePack do
	it_behaves_like ACoder, {"items" => [1, 2, 3]}
end

describe Async::Job::Coder::Marshal do
	it_behaves_like ACoder, {"items" => [1, 2, 3]}
end

describe Async::Job::Coder do
	with ".Time" do
		with "Time object" do
			let(:time) {Time.at(1234567890)}
			
			it "returns the time object unchanged" do
				expect(subject.Time(time)).to be == time
			end
		end
		
		with "Integer timestamp" do
			let(:timestamp) {1234567890}
			
			it "converts to Time using Time.at" do
				result = subject.Time(timestamp)
				expect(result).to be_a(Time)
				expect(result.to_i).to be == timestamp
			end
		end
		
		with "String timestamp" do
			let(:time_string) {"2024-01-15 10:30:00"}
			
			it "converts to Time using Time.new" do
				result = subject.Time(time_string)
				expect(result).to be_a(Time)
				expect(result.to_s).to be(:include?, "2024-01-15")
			end
		end
		
		with "nil value" do
			it "returns nil unchanged" do
				expect(subject.Time(nil)).to be_nil
			end
		end
		
		with "other object types" do
			let(:date) {Date.new(2024, 1, 15)}
			
			it "calls to_time on the object" do
				result = subject.Time(date)
				expect(result).to be_a(Time)
				expect(result.year).to be == 2024
				expect(result.month).to be == 1
				expect(result.day).to be == 15
			end
		end
	end
end
