# Redis Queue

This guide gives a brief overview of the implementation of the Redis queue.

## Overview

The Redis queue plays a pivotal role in facilitating a sophisticated and reliable job queue architecture, designed to handle diverse processing needs with efficiency and resilience. The architecture is thoughtfully split into three distinct components, each serving a critical function in the lifecycle of a job: the ready queue, the delayed queue, and the processing queue.

## Ready Queue

The ready queue is where jobs that are immediately available for processing are stored. When a job is submitted and is ready to be executed without any delay, it is placed into this queue. Worker processes constantly listen for new jobs on the ready queue, dequeuing and executing them as soon as they become available. This queue operates on a FIFO (First In, First Out) basis, ensuring that jobs are processed in the order they were received.

## Delayed Queue

The delayed queue holds jobs that are not meant to be executed immediately but at a specified future time. This functionality is crucial for tasks that need to be executed at a later stage, such as scheduled notifications or time-dependent processes. Jobs in the delayed queue are sorted according to their execution time. When possible, they are moved to the ready queue to be executed by the next available worker. This transition is managed through Redis's sorted sets, allowing efficient retrieval and management of timed events.

## Processing Queue

Once a job is dequeued from the ready queue, it enters the processing queue, signifying that it is currently being executed by a worker. The processing queue is crucial for tracking the progress of jobs and for ensuring that jobs can be retried or recovered in case of worker failure. Each worker emits a heartbeat, and if a worker fails to emit a heartbeat within a specified time, any jobs associated with that worker are automatically moved back to the ready queue for reprocessing.
