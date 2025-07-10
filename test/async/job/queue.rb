# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2025, by Shopify Inc.

require "async/job/queue"

class Client
	attr_reader :called, :arguments
	def initialize
		@called = false
		@arguments = nil
	end
	def call(*arguments)
		@called = true
		@arguments = arguments
	end
end

class Server
	attr_reader :started, :stopped
	def initialize
		@started = false
		@stopped = false
	end
	def start
		@started = true
	end
	def stop
		@stopped = true
	end
end

describe Async::Job::Queue do
	let(:client) {Client.new}
	let(:server) {Server.new}
	let(:delegate) {Object.new}
	let(:queue) {Async::Job::Queue.new(client, server, delegate)}

	it "delegates call to client" do
		queue.call(1, 2, 3)
		expect(client.called).to be == true
		expect(client.arguments).to be == [1, 2, 3]
	end

	it "delegates start to server" do
		queue.start
		expect(server.started).to be == true
	end

	it "delegates stop to server" do
		queue.stop
		expect(server.stopped).to be == true
	end

	it "exposes client, server, and delegate attributes" do
		expect(queue.client).to be == client
		expect(queue.server).to be == server
		expect(queue.delegate).to be == delegate
	end
end
