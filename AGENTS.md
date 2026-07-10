# AGENTS.md

## Project coding policy

This repository prioritizes readability, reviewability, and small safe changes.

Codex must follow these rules for all code changes.

## General rules

- Prefer simple, explicit, boring code over clever or compact code.
- Optimize for human reviewability, not for minimum line count.
- Keep changes small and localized.
- Do not perform broad refactors unless explicitly requested.
- Before editing, explain the plan and list the files likely to change.
- After editing, summarize:
  - What changed
  - Why it changed
  - How to test it
  - Any behavior changes or risks

## Readability rules

- Prefer named functions over complex inline logic.
- Avoid deeply nested control flow.
- Prefer early returns and guard clauses when they improve readability.
- Avoid hidden side effects.
- Avoid mixing parsing, validation, state update, ROS I/O, and logging in one function.
- A function should usually do one thing.

## Function size

- Prefer functions under 40 lines.
- If a function exceeds about 40 lines, consider splitting it without harming the structure.
- If a function exceeds 60 lines, explain why it should remain as one function.
- Avoid functions with more than 3 levels of indentation.
- Prefer at most 4 parameters. If more are needed, consider a config struct/dataclass.

## File size

- Keep files focused on one responsibility.
- If a Python file exceeds about 400 lines, consider splitting by responsibility.
- If a C++ source file exceeds about 700 lines, consider splitting by responsibility.
- Header files should expose interfaces, not large implementations.

## C/C++ rules

- Prefer clear ownership and lifetime.
- Avoid raw owning pointers.
- Prefer RAII.
- Prefer explicit names over abbreviations.
- Avoid complex templates unless explicitly needed.
- Avoid macros unless there is no safer alternative.
- Avoid lambdas by default.
- Lambdas are allowed only for short local operations, usually 1 to 3 lines.
- Do not use lambdas that capture many variables or hide important control flow.
- Prefer named helper functions for non-trivial logic.

## Python rules

- Follow PEP 8 style.
- Use type hints for public functions and non-trivial internal functions.
- Prefer dataclasses for structured configuration/state.
- Avoid nested functions unless the scope is truly local and readability improves.
- Avoid complex lambdas. Lambdas are allowed only for simple key functions.
- Prefer explicit control flow over dense comprehensions when logic is non-trivial.
- Do not hide important side effects inside property methods.

## ROS2 rules

- Keep ROS I/O separate from core business logic when practical.
- Do not mix parameter loading, subscription callbacks, state transitions, and publishing in one large function.
- Use clear names for topics, services, parameters, and state transitions.
- Log important state changes.
- Avoid excessive logging inside high-frequency callbacks.
- Do not change launch/config behavior unless explicitly requested.

## Review behavior

When asked to review code:

- Do not edit files first.
- First inspect the smallest necessary set of files.
- Report issues by severity:
  - Critical: correctness, safety, data loss, runtime failure
  - Major: maintainability, architecture, hidden coupling
  - Minor: naming, formatting, comments
- Include exact file/function names.
- Prefer actionable suggestions.
- Do not nitpick style that is already handled by formatters.

## References

See:

- `docs/code-style.md`
- `docs/code-review.md`
