# Robot Safety Guide

## Scope

Use this guide for changes that can publish motion commands, change command
ownership, alter stop behavior, or affect autonomous execution.

## Required principles

- Keep command ownership and stop behavior explicit.
- Reject invalid state transitions before publishing a command.
- On uncertain or failed input, prefer the safer non-moving state.
- Do not hide motion, retry, or recovery behavior inside generic wrappers.
- Keep safety checks close to the boundary where untrusted data enters.
- Avoid blocking ROS callbacks with waits, retries, hardware I/O, or subprocesses.
- Make timer, future, thread, process, and shutdown cleanup ownership explicit.

## Validation order

Before testing on a real robot:

1. Review the affected command and state-transition paths.
2. Run static checks and unit tests for pure logic when available.
3. Build and test the affected ROS 2 package.
4. Verify topics, services, actions, parameters, QoS, and TF frames.
5. Test without hardware or in simulation when practical.
6. Use reduced speed and a controlled workspace for the first real-robot test.

## Review questions

- Can any failure path publish an unintended command?
- Is repeated, delayed, malformed, or cancelled input handled safely?
- Is the active command owner always clear?
- Can shutdown or exception handling leave motion active?
- Are units, coordinate frames, limits, and timeout behavior explicit?
- Is the recovery path safer than continuing with uncertain state?

## Documentation

Document safety-relevant assumptions and side effects in concise Korean comments
or docstrings. Keep ROS interface names, units, coordinate frames, API names,
and established technical terms in English.
