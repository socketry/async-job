# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

module Async
  module Job
    class Generic
      def self.enqueue(...)
        self.new(...).enqueue
      end

      def initialize(id, scheduled_at: nil)
        @id = id
        @scheduled_at = scheduled_at
      end

      attr :id
      attr :scheduled_at

      def serialize
        raise NotImplementedError
      end

      def call
        raise NotImplementedError
      end
    end
  end
end
