# Comparison of Sidekiq & Async::Job::Adapter::ActiveJob

This is a small benchmark, scheduling 10,000 jobs which sleep for 1ms each.

## Usage

### Sidekiq

Start the server using `./sidekiq-server.rb`.

Run the client using `./sidekiq-client.rb`. Note the start time and total execution time.

Switch over to the server and note the last performed at time. Compare the start time from the client with this time to get total end-to-end execution time.

### Async::Job::Adapter::ActiveJob

Start the server using `./async-job-server.rb`.

Run the client using `./async-job-client.rb`. Note the start time and total execution time.

Switch over to the server and note the last performed at time. Compare the start time from the client with this time to get total end-to-end execution time.

## Sample Data

### Sidekiq

```
Started at: 135507.487672458
Ended at: 135508.273666704
Total time: 0.785994245990878

Performed at: 135509.920782661
```

Total runtime: 2.433110202998758

### Async::Job::Adapter::ActiveJob

```
Started at: 134859.846875442
Ended at: 134860.819802786
Total time: 0.9729273440025281

Performed at: 134860.824373028
```

Total runtime: 0.9774975860200357

## Observations

It should be noted that `Async::Job` is a library for building job queues, but does not provide in and of itself an end to end scheduler. The adapter for `ActiveJob` is directly built on the queues created by `Async::Job`. This is in comparison to Sidekiq which does provide an end to end interface for executing jobs. As such, `ActiveJob`'s sidekiq wrapper is actually a 2nd layer on top of sidekiq.