# Releases

## v0.10.1

  - Add release notes and modernize code.
  - Add external tests.
  - Improve test formatting and modernize code.
  - Achieve 100% test coverage.
  - Achieve 100% documentation coverage.
  - Add agent context.

## v0.10.0

  - **Breaking Change**: Extract redis support into separate gem.
  - Remove block argument from job processing as it's no longer particularly useful.

## v0.9.2

  - Add documentation.
  - Revert `fail` -\> `retry` behavior.

## v0.9.1

  - Minor improvements.

## v0.9.0

  - **Breaking Change**: Reorganize processor code and add delayed processor.
  - **Breaking Change**: Rename `queue` -\> `processor` and `pipeline` -\> `queue`.
  - **Breaking Change**: Rename pipeline producer/consumer -\> client/server.
  - **Breaking Change**: Rename `Backend` -\> `Queue`.
  - Add generic backend implementation.
  - Fix some words and reduce logging.

## v0.8.0

  - Add `#start`/`#stop` methods.

## v0.7.1

  - Minor improvements to aggregate backend.
  - Ensure aggregate buffer shuts down gracefully (\#4).

## v0.7.0

  - Add aggregation backend.
  - Add documentation regarding aggregate backend.
  - Prefer `before do` ... in tests.

## v0.6.0

  - Add support for delegate pass-through.
  - Modernize gem.
  - Add client and server example (\#3).
  - Fix gem name in guide.

## v0.5.0

  - Add benchmark example.
  - Add support for `Async::Idler`.
  - Add link to `async-job-adapter-active_job`.

## v0.4.2

  - "Fix" JSON coder.

## v0.4.1

  - Fix enqueue typo.
  - Support returning nil =\> no-op in `Builder#build`.

## v0.4.0

  - Add more documentation.
  - Modernize gem.
  - Add pipeline builder.
  - **Breaking Change**: Use String key for "scheduled\_at".
  - **Breaking Change**: Prefer `delegate` terminology for next step in the queue.
  - **Breaking Change**: Rename `enqueue` -\> `call` for consistency with queue metaphor.
  - **Breaking Change**: Rename `perform_at` -\> `scheduled_at`.
  - Add support for coders, and remove `schedule` in favour of `enqueue`.
  - Add redis to workflows.

## v0.3.0

  - Add inline backend + explicit handler for processing jobs.

## v0.2.1

  - Minor fixes.

## v0.2.0

  - Add generic backend constructor + tests.

## v0.1.0

  - Don't log all the things.
  - Move ActiveJob adapter code to `async-job-adapter-active_job`.
  - Add ActiveJobServer service.
  - Fix invalid syntax.
  - Add utopia-project for documentation.
  - Add some basic tests.
  - Add active\_job adapter.

## v0.0.0

  - Initial release with `bake-gem` for release management.
  - Add example client and server.
  - Split `test.rb` -\> `client.rb` and `server.rb` for easier testing.
  - Tidy up job store implementation.
  - Add generic job implementation.
  - Redis backend working.
  - Initial noodling.
