require_relative '../../lib/async/job/generic'

class ExampleJob < Async::Job::Generic
  def perform(message:)
    puts message
  end
end
