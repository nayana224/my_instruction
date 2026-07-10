# Code Review Guide

Use this guide when reviewing changes. Review findings before style
suggestions, and do not edit files unless the review request explicitly asks
for changes.

## Review Priorities

Review in this order:

1. Correctness and public-interface compatibility
2. Runtime and hardware safety
3. Validation and test evidence
4. Simplicity and maintainability
5. Readability and style

Do not focus on formatting that the configured tools can check automatically.

## Required Review Checks

### Correctness and Compatibility

- Does the code handle expected, invalid, and boundary inputs?
- Are all state transitions valid, including repeated requests, cancellation,
  failure, and recovery paths?
- Does the change preserve topics, services, actions, parameters, TF frames,
  CSV formats, and saved-pose formats, or update every downstream user?
- Are configuration defaults, validation, and migration behavior clear?
- Could the code behave differently on the Jetson or a different ROS 2 Humble
  environment?

### Runtime and Safety

- Does any path publish motion commands, change command ownership, or alter
  stop behavior? If so, is the safe failure path explicit?
- Are motor, serial, LiDAR, tracking, localization, and autonomous-replay
  failures handled conservatively?
- Are callbacks non-blocking and safe for the configured executor model?
- Are shared state, timers, futures, subprocesses, and shutdown cleanup owned
  and synchronized clearly?
- Is QoS compatible with the publishers and subscribers that must interoperate?
- Does the change follow the applicable rules in [`safety.md`](safety.md)?

### Validation and Tests

- Is there automated test coverage for changed pure logic, state transitions,
  conversions, or error paths when practical?
- Has the affected package been built and tested with
  `colcon test --packages-select <package>` when the environment permits?
- If tests cannot run, does the review record why and identify the remaining
  risk?
- For ROS interface or workflow changes, are the relevant topic, service,
  action, launch, or integration checks identified?
- For hardware-sensitive changes, is a no-hardware or dry-run check identified
  before real-robot testing?

### Maintainability and Readability

- Can the main control flow be understood in one pass?
- Is each function responsible for one cohesive operation?
- Is pure policy or conversion logic separated from ROS I/O where useful?
- Are names domain-specific and clear, including units where relevant?
- Is nesting necessary, or can guards and named helpers make outcomes clearer?
- Does any wrapper, lambda, property, or abstraction hide side effects or add
  indirection without a useful boundary?
- Is the file and package still the right owner for this behavior?

### Language-Specific Checks

For Python:

- Are type hints present where they clarify a public or non-trivial interface?
- Are exceptions handled explicitly with useful context?
- Are dataclasses or configuration objects used when they clarify related
  fields?
- Does the change follow `flake8` configuration and
  [`python-docstring-style.md`](python-docstring-style.md)?

For C and C++:

- Is ownership and lifetime clear?
- Are references, pointers, and callback captures safe?
- Are headers minimal and implementation details kept private?
- Are compiler warnings addressed rather than hidden?

## Finding Severity

- **Critical:** Can cause unsafe robot motion, data loss, a crash, a deadlock,
  or an unrecoverable workflow failure.
- **Major:** Can produce incorrect behavior, break an interface, leave a
  failure path unhandled, or make a likely future change unsafe or unreliable.
- **Minor:** Does not change behavior now, but reduces clarity, consistency, or
  testability.

Do not invent a severity when there is no meaningful issue. State explicitly
when no findings are identified and list any unverified risks or test gaps.

## Review Output Format

```text
Summary:
- Scope reviewed and verification performed.

Critical:
- [path:line or symbol] issue, concrete risk, suggested fix

Major:
- [path:line or symbol] issue, concrete risk, suggested fix

Minor:
- [path:line or symbol] issue, suggested fix

Validation gaps:
- Tests or runtime checks not run, reason, and remaining risk.

Suggested next step:
- Highest-value follow-up action.
```

Omit empty severity sections when there are findings only at other levels.

## Codex Review Prompt

```text
Review this code without editing files.

Use docs/code-review.md and docs/code-style.md.
Review correctness, public ROS interface compatibility, runtime and hardware
safety, validation, test gaps, maintainability, and readability in that order.

For ROS 2 changes, check state transitions, QoS, callback blocking, executor or
shared-state safety, shutdown cleanup, parameters, command ownership, and safe
failure behavior when relevant.

Report only actionable findings as Critical / Major / Minor with
[path:line or symbol], risk, and suggested fix. Include a Validation gaps
section. Do not edit files or nitpick formatting handled by configured tools.
```
