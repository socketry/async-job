# Async::Job

Provides an asynchronous job server.

[![Development Status](https://github.com/socketry/async-job/workflows/Test/badge.svg)](https://github.com/socketry/async-job/actions?workflow=Test)

## Usage

Please see the [project documentation](https://socketry.github.io/async-job/) for more details.

  - [Getting Started](https://socketry.github.io/async-job/guides/getting-started/index) - This guide gives you an overview of the `async-job` gem and explains the core concepts.

  - [Inline Queue](https://socketry.github.io/async-job/guides/inline-queue/index) - This guide explains how to use the Inline queue to execute background jobs.

  - [Aggregate Queue](https://socketry.github.io/async-job/guides/aggregate-queue/index) - This guide explains how to use the Aggregate queue to reduce input latency and improve the performance of your application.

## Releases

Please see the [project releases](https://socketry.github.io/async-job/releases/index) for all releases.

### v0.10.2

  - Minor code cleanup.

### v0.10.1

  - Add release notes and modernize code.
  - Add external tests.
  - Improve test formatting and modernize code.
  - Achieve 100% test coverage.
  - Achieve 100% documentation coverage.

### v0.10.0

  - **Breaking Change**: Extract redis support into separate gem.
  - Remove block argument from job processing as it's no longer particularly useful.

### v0.9.2

  - Add documentation.
  - Revert `fail` -\> `retry` behavior.

### v0.9.1

  - Minor improvements.

### v0.9.0

  - **Breaking Change**: Reorganize processor code and add delayed processor.
  - **Breaking Change**: Rename `queue` -\> `processor` and `pipeline` -\> `queue`.
  - **Breaking Change**: Rename pipeline producer/consumer -\> client/server.
  - **Breaking Change**: Rename `Backend` -\> `Queue`.
  - Add generic backend implementation.
  - Fix some words and reduce logging.

### v0.8.0

  - Add `#start`/`#stop` methods.

### v0.7.1

  - Minor improvements to aggregate backend.
  - Ensure aggregate buffer shuts down gracefully (\#4).

### v0.7.0

  - Add aggregation backend.
  - Add documentation regarding aggregate backend.
  - Prefer `before do` ... in tests.

### v0.6.0

  - Add support for delegate pass-through.
  - Modernize gem.
  - Add client and server example (\#3).
  - Fix gem name in guide.

## See Also

  - [async-job-processor-redis](https://github.com/socketry/async-job-processor-redis) - Redis processor for `async-job` (similar to Sidekiq).
  - [async-job-adapter-active\_job](https://github.com/socketry/async-job-adapter-active_job) - ActiveJob adapter for `async-job`.

## Contributing

We welcome contributions to this project.

1.  Fork it.
2.  Create your feature branch (`git checkout -b my-new-feature`).
3.  Commit your changes (`git commit -am 'Add some feature'`).
4.  Push to the branch (`git push origin my-new-feature`).
5.  Create new Pull Request.

### Developer Certificate of Origin

In order to protect users of this project, we require all contributors to comply with the [Developer Certificate of Origin](https://developercertificate.org/). This ensures that all contributions are properly licensed and attributed.

### Community Guidelines

This project is best served by a collaborative and respectful environment. Treat each other professionally, respect differing viewpoints, and engage constructively. Harassment, discrimination, or harmful behavior is not tolerated. Communicate clearly, listen actively, and support one another. If any issues arise, please inform the project maintainers.
