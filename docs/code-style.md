# Code Style Guide

## Goal

Code in this repository should be easy to read, review, test, and modify
without obscuring ROS 2 or hardware-related behavior.

This guide defines source-level conventions. Use
[`python-docstring-style.md`](python-docstring-style.md) for Python comments
and docstrings, and use `flake8` settings in each Python package as the
enforced formatting baseline.

## Rule Levels

- **Required**: apply to new or modified code unless a documented exception is
  necessary.
- **Recommended**: apply when it improves clarity without adding unnecessary
  indirection.

## Design Principles

1. **Required:** Keep each package and file focused on one clear responsibility.
2. **Required:** Preserve public ROS interfaces and saved-data formats unless
   all downstream users are updated together.
3. **Recommended:** Prefer explicit, domain-specific names over clever
   abstractions.
4. **Recommended:** Make small, behavior-preserving changes when refactoring.
5. **Required:** Separate pure policy, conversion, and validation logic from
   ROS I/O when it can be tested independently.
6. **Required:** Keep safety-sensitive behavior explicit: command ownership,
   stop behavior, state transitions, and failure recovery must not be hidden.

## Function Design

For functions that accept input and change state, the preferred flow is:

1. Validate input and preconditions.
2. Prepare or convert data.
3. Execute one cohesive domain action.
4. Return a result or report a contextual error.

This is a guideline, not a required template for simple getters, lifecycle
methods, cleanup methods, or thin ROS adapters.

Split a function when one or more of these conditions apply:

- It combines independent policy decisions and ROS or file I/O.
- Its main control flow cannot be understood in one pass.
- It has more than one externally visible side effect that are not part of one
  atomic workflow step.
- A pure portion can be tested without ROS, hardware, or the filesystem.
- Nested conditions make success, failure, or stop behavior unclear.

ROS callbacks should validate minimal input, delegate non-trivial work to named
methods, and avoid blocking work. A callback may remain small even when the
delegated workflow is necessarily complex.

## Naming

Use names that explain intent and domain meaning.

```python
load_robot_config()
validate_transition()
publish_mode_status()
```

Avoid vague names such as `process`, `handle`, `do_work`, or `manager` unless
the scope makes the subject unambiguous. Generic loop variables are acceptable
in very small scopes.

Use clear English names for packages, files, classes, functions, variables,
topics, services, actions, parameters, and state transitions. Include units in
variable names when a value could otherwise be misread, such as
`timeout_seconds` or `max_speed_mps`.

## Abstractions, Lambdas, and Wrappers

Use an abstraction only when it establishes a useful boundary:

- It hides an external API or hardware dependency.
- It isolates ROS I/O from testable core logic.
- It gives domain meaning to a repeated operation.
- It makes a safety or state-transition contract easier to see.

Do not add a wrapper that only renames a single call, hides side effects, or
adds another navigation step without simplifying the caller.

Avoid lambdas by default. A lambda is acceptable for a short, local,
side-effect-free expression such as a sort key. Use a named function or method
for callbacks and for any lambda that performs domain logic, mutation, or I/O.

## Comments and Documentation

Comments explain *why*, constraints, ordering, units, frames, or safety
implications; they do not narrate obvious statements. Keep all comments and
docstrings in English.

Follow [`python-docstring-style.md`](python-docstring-style.md) for module,
class, function, and ROS-facing documentation. In particular, document public
ROS contracts and safety-relevant side effects when they are not obvious from
the function name.

## Error Handling and Logging

- **Required:** Validate untrusted parameters, messages, file contents, and
  state-transition preconditions before use.
- **Required:** Do not silently swallow exceptions.
- **Required:** Include actionable context in errors, including the affected
  resource, requested operation, and relevant state when safe to log.
- **Required:** Make failure and safe-stop paths explicit for motor commands,
  tracking, localization, and autonomous workflows.
- **Recommended:** Log important state changes once; avoid repeated logs in
  high-frequency callbacks.

## Python

- Follow PEP 8 as interpreted by the package's configured `flake8` checks.
- The current repository baseline uses a maximum line length of 100 where
  configured; do not reformat unrelated lines solely to meet a different tool.
- Use type hints for public functions and non-trivial internal functions.
- Prefer dataclasses for structured configuration or state when they make
  ownership and fields clearer.
- Prefer explicit control flow over dense comprehensions when logic is
  non-trivial.
- Do not hide important side effects in properties, destructors, or imports.

## C and C++

- Prefer RAII and clear ownership; avoid raw owning pointers.
- Use `const` when it communicates intent.
- Keep headers focused on interfaces and move implementation details to source
  files when practical.
- Avoid complex templates and macros unless they provide a clear benefit that
  safer language features cannot provide.
- Treat compiler warnings enabled by the package as issues to resolve, not
  suppress by default.

## ROS 2

- Keep ROS I/O, parameter loading, state-transition rules, and business logic
  separated where practical.
- Keep topic, service, action, parameter, frame, and mode names explicit and
  stable.
- Validate parameters at startup or before first use, including ranges, units,
  and dependent settings.
- Choose QoS deliberately and document non-default QoS when compatibility is
  not self-evident.
- Do not block executor callbacks with long I/O, waits, or retries.
- Make timer, future, process, and shutdown cleanup ownership explicit.
- For changes that can publish motion commands or alter command ownership,
  follow [`safety.md`](safety.md) and validate without hardware before robot
  testing whenever possible.
