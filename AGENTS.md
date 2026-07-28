# AGENTS.md

## Project coding policy

This repository prioritizes readability, reviewability, and small safe changes.

Codex must follow these rules for all code changes.

## General rules

- Prefer simple, explicit, boring code over clever or compact code.
- Optimize for human reviewability, not for minimum line count.
- Prefer the solution with the fewest concepts, not necessarily the fewest lines.
- Keep changes small and localized.
- Do not perform broad refactors unless explicitly requested.
- Before editing, explain the plan and list the files likely to change.
- After editing, summarize:
  - What changed
  - Why it changed
  - How to test it
  - Any behavior changes or risks

## Simplicity and abstraction policy

Do not add a function, class, interface, wrapper, configuration object, design
pattern, or generic mechanism unless it reduces the total effort needed to
understand, test, or safely change the code.

A new abstraction must provide at least one concrete benefit:

- isolate a real dependency or side effect,
- represent a stable domain concept,
- remove meaningful repeated logic,
- enforce an important invariant,
- or make independently testable logic possible.

Moving code behind another name is not, by itself, a simplification.
Do not optimize for hypothetical future reuse.

- Do not introduce factories, registries, plugin systems, strategy classes,
  dependency-injection containers, or generic frameworks unless the current
  task requires them.
- Do not add extension points without a concrete caller or use case.
- Prefer a small amount of obvious duplication over a premature abstraction.

## Readability rules

- Prefer named functions over complex inline logic.
- Avoid deeply nested control flow.
- Prefer early returns and guard clauses when they improve readability.
- Avoid hidden side effects.
- Avoid mixing parsing, validation, state update, ROS I/O, and logging in one function.
- A function should usually do one thing.

## Function size

- Function length is a warning signal, not a target.
- Prefer functions under 40 lines when this preserves a cohesive workflow.
- Do not split a function only to satisfy a line-count guideline.
- A cohesive longer function is preferable to several tiny helpers that require
  jumping between symbols to understand one workflow.
- Extract a helper only when it has a clear responsibility, removes meaningful
  duplication, isolates testable logic, or establishes a real dependency boundary.
- Do not extract one-line or two-line helpers that merely rename obvious code.
- If a function exceeds 60 lines, explain why it should remain as one function.
- Avoid functions with more than 3 levels of indentation.
- Parameter count is a readability signal, not a hard limit.
- Group parameters only when they form a stable domain concept or are commonly
  passed together.
- Do not introduce a dataclass solely to reduce the visible parameter count.

## Class design

- Do not create a class only to group related functions.
- Prefer module-level functions when there is no meaningful state, lifecycle,
  ownership, resource management, or polymorphic behavior.
- Avoid static-method-only classes. Use a module or namespace instead.
- Avoid classes whose only method is `run`, `execute`, `process`, or `handle`
  unless they implement an established interface.
- Prefer composition over inheritance.
- Do not introduce an abstract base class until at least two real implementations
  or a required framework interface exist.

## Type hint restraint

- Type hints must make an interface easier to understand, not merely make it longer.
- Use type hints for public functions, shared data structures, and non-trivial
  boundaries where they prevent ambiguity.
- Simple local variables and obvious private helpers do not require annotations.
- Do not annotate every intermediate variable.
- Avoid complex nested generic types in function signatures.
- Introduce a named type alias only when it represents a stable domain concept or
  significantly improves repeated signatures.
- Do not create `Protocol`, `Generic`, `TypeVar`, overload sets, or custom typing
  utilities for a single implementation or hypothetical future reuse.
- Prefer a simple concrete type over a highly generic interface when only one
  concrete use exists.
- Do not use `Any` merely to silence the type checker. Fix the boundary or document
  why the dynamic value is unavoidable.
- Do not add casts, ignores, or typing-only wrappers unless the reason is clear.
- Runtime validation belongs at trust boundaries; type hints do not replace it.

## Validation boundaries

- Validate data at trust boundaries such as user input, ROS messages, parameters,
  files, network or serial input, hardware responses, and public APIs.
- Do not repeatedly validate the same invariant in every internal helper.
- After validation at a clear boundary, internal functions may rely on the
  documented invariant.
- Do not add defensive checks for impossible states without evidence that the
  state can occur.
- Avoid broad exception handling around code that cannot meaningfully recover.

## File size

- Keep files focused on one responsibility.
- If a Python file exceeds about 400 lines, consider splitting by responsibility.
- If a C++ source file exceeds about 700 lines, consider splitting by responsibility.
- Header files should expose interfaces, not large implementations.
- Do not create generic `utils`, `helpers`, or `common` modules when a
  domain-specific module name is available.

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
- Prefer dataclasses only for real structured configuration or state.
- Avoid nested functions unless the scope is truly local and readability improves.
- Avoid complex lambdas. Lambdas are allowed only for simple key functions.
- Prefer explicit control flow over dense comprehensions when logic is non-trivial.
- Do not hide important side effects inside property methods.
- Avoid metaprogramming, reflection, dynamic attribute access, and decorators with
  hidden behavior unless the task clearly requires them.
- Avoid `getattr`, `setattr`, `globals`, `locals`, `eval`, and `exec` for normal
  application control flow.
- Avoid multiple inheritance except for framework-required mixins.

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
- Check whether a new function, class, interface, dataclass, enum, type alias,
  protocol, wrapper, or generic abstraction reduces total reasoning effort.

## References

See:

- `docs/code-style.md`
- `docs/code-review.md`
