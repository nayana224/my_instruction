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
7. **Required:** Prefer the solution with the fewest concepts, not necessarily
   the fewest lines.

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

Do not split a function only to satisfy a line-count guideline. A cohesive
longer function is preferable to several tiny helpers that force the reader to
jump between symbols. Do not extract a helper that merely renames one or two
obvious statements.

ROS callbacks should validate minimal input, delegate non-trivial work to named
methods, and avoid blocking work. A callback may remain small even when the
delegated workflow is necessarily complex.

## Class Design

Create a class when it owns meaningful state, invariants, resources, lifecycle,
or a stable external-system boundary. Do not create a class only to group
related functions.

- Prefer module-level functions when no meaningful state or lifecycle exists.
- Avoid static-method-only classes.
- Avoid classes whose only operation is a vague `run`, `execute`, `process`, or
  `handle` method unless a framework requires the interface.
- Prefer composition over inheritance.
- Do not introduce an abstract base class for one implementation or hypothetical
  future variants.
- Use inheritance only when substitution is real and the base contract is clear.

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

Avoid generic structural names such as `Manager`, `Processor`, `Handler`,
`Helper`, `Utils`, `Common`, `Factory`, `Base`, or `Context` when a
more specific domain name is available.

Use clear English names for packages, files, classes, functions, variables,
topics, services, actions, parameters, and state transitions. Include units in
variable names when a value could otherwise be misread, such as
`timeout_seconds` or `max_speed_mps`.

Do not create generic `utils.py`, `helpers.py`, or `common.py` modules when a
domain-specific module name is available.

## Abstractions, Lambdas, and Wrappers

Use an abstraction only when it establishes a useful boundary:

- It hides an external API or hardware dependency.
- It isolates ROS I/O from testable core logic.
- It gives domain meaning to a repeated operation.
- It makes a safety or state-transition contract easier to see.
- It enforces an important invariant.

Do not add a wrapper that only renames a single call, hides side effects, or
adds another navigation step without simplifying the caller.

Do not introduce factories, registries, plugin systems, strategy objects,
dependency-injection containers, or extension hooks for hypothetical future
reuse. A small amount of obvious duplication is preferable to a premature or
incorrect abstraction.

Avoid lambdas by default. A lambda is acceptable for a short, local,
side-effect-free expression such as a sort key. Use a named function or method
for callbacks and for any lambda that performs domain logic, mutation, or I/O.

## Type Hints

Type hints should reduce ambiguity at important interfaces. They are not a goal
by themselves and should not be added mechanically to every variable or helper.

Use type hints for:

- public functions and methods,
- ROS-independent domain boundaries,
- shared structured data,
- non-trivial return values,
- and inputs whose units, optionality, or accepted forms are otherwise unclear.

Do not require type hints for:

- obvious local variables,
- short private helpers whose types are clear from nearby code,
- loop variables,
- or intermediate expressions where an annotation adds no information.

Keep signatures readable:

- Prefer concrete built-in and standard-library types when sufficient.
- Avoid deeply nested generics in public signatures.
- Create a named type alias only when it expresses a stable domain concept or
  substantially clarifies a repeated signature.
- Do not introduce `Protocol`, `Generic`, `TypeVar`, overload sets, or custom
  typing utilities for one implementation or speculative reuse.
- Do not create wrapper dataclasses solely to make a type checker happy or to
  reduce the visible parameter count.
- Do not use `Any` merely to silence errors. Keep dynamic data at a clear
  boundary and document why it is unavoidable.
- Avoid unnecessary `cast`, `# type: ignore`, and typing-only adapters. When one
  is necessary, explain the unsupported or dynamic boundary.
- Type hints do not replace runtime validation of ROS messages, parameters,
  files, hardware responses, or other untrusted data.

## Validation Boundaries

Validate untrusted data at clear boundaries such as ROS callbacks, parameter
loading, files, network or serial input, public APIs, and hardware responses.
After validation, internal helpers may rely on the documented invariant.

Do not repeat the same defensive checks throughout every internal function.
Do not add checks for impossible states without evidence that they can occur.
Avoid broad exception handling where the code cannot recover meaningfully.

## Comments and Documentation

Comments explain *why*, constraints, ordering, units, frames, or safety
implications; they do not narrate obvious statements.

Write comments and docstrings in concise, natural Korean. Keep code identifiers,
official API names, library names, ROS interface names, units, coordinate frames,
and established technical terms in their original English form. Do not translate
technical terms when the Korean wording would be less clear.

- Do not comment every line, assignment, branch, or function call.
- Do not restate code in natural language.
- Prefer clearer names and simpler control flow over explanatory comments.
- Do not add docstrings mechanically to every function, method, or class.
- Short private helpers with self-explanatory names do not require docstrings.
- A docstring must add information not already obvious from the name, signature,
  type hints, and nearby context.
- Do not leave commented-out code; use version control instead.
- Update or remove comments whenever the related behavior changes.
- Avoid vague TODO comments. State the concrete missing work and why it remains.

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
- Use type hints according to the Type Hints section above.
- Prefer dataclasses for real structured configuration or state when they make
  ownership and fields clearer.
- Prefer explicit control flow over dense comprehensions when logic is
  non-trivial.
- Do not hide important side effects in properties, destructors, or imports.
- Avoid metaprogramming, reflection, dynamic attribute access, multiple
  inheritance, and decorators with hidden control flow unless clearly required.
- Avoid `getattr`, `setattr`, `globals`, `locals`, `eval`, and `exec` for normal
  application control flow.

## C and C++

- Prefer RAII and clear ownership; avoid raw owning pointers.
- Use `const` when it communicates intent.
- Keep headers focused on interfaces and move implementation details to source
  files when practical.
- Avoid complex templates and macros unless they provide a clear benefit that
  safer language features cannot provide.
- Prefer concrete types and ordinary functions when only one concrete use exists.
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

## YAML and configuration files

- Use two spaces for indentation and never use tabs.
- Keep parameter names in English and prefer explicit domain-specific names.
- Include units in names when values may be ambiguous, such as
  `timeout_seconds`, `max_speed_mps`, or `angle_radians`.
- Keep related parameters together, but avoid deeply nested structures when a
  flatter structure is easier to inspect.
- Do not keep unused, deprecated, duplicated, or commented-out parameters.
- Add a concise Korean comment only when a unit, valid range, dependency,
  hardware assumption, compatibility constraint, or safety implication is not
  obvious.
- Do not duplicate the same configuration value across files without a clear
  ownership reason.
- Treat parameter renames and default-value changes as interface changes.
- Validate ranges, units, required keys, and dependent settings at startup or at
  the configuration-loading boundary.

## ROS 2 launch files

- Keep launch files declarative and easy to inspect.
- Avoid `OpaqueFunction` and runtime Python logic unless normal launch actions
  and substitutions cannot express the requirement clearly.
- Do not create launch arguments for values that are not expected to vary.
- Keep a node's parameters, remappings, namespace, condition, and output behavior
  visible near that node declaration.
- Split a launch file only when the extracted file represents a reusable
  subsystem or independently launchable workflow.
- Do not hide safety-relevant parameter overrides, controller selection, command
  ownership, or topic remapping behind helper layers.
- Keep argument names and defaults stable unless all callers are updated.
- Prefer explicit launch composition over clever substitution chains.

## ROS package metadata and build files

- Add only dependencies that are directly required by the package.
- Do not add broad dependency groups or optional frameworks for hypothetical
  future use.
- Keep `package.xml` dependency declarations grouped consistently.
- Keep `CMakeLists.txt` ordered by package discovery, targets, target
  dependencies, installation, exports, and tests.
- Do not hide build behavior inside complex macros unless the macro is reused
  meaningfully and simplifies each caller.
- Remove obsolete dependencies when their final use is removed.
- Keep target names, install paths, exported interfaces, and generated artifacts
  explicit.
- Preserve package names, executable names, library names, and installed paths
  unless all downstream launch files and packages are updated.

## Validation tools

- Run the most relevant validation tools already available in the project
  environment.
- Do not install tools, upgrade dependencies, or change the project environment
  automatically unless requested.
- If a recommended check cannot run, record the missing check, the reason, and
  the remaining risk.
- Do not treat formatting-only validation as a substitute for runtime, interface,
  configuration, or hardware-safety checks.

## Generated files

- Do not edit generated files directly.
- Edit the source schema, template, Xacro, message definition, or generator input.
- Do not commit build output, caches, logs, or temporary generated files unless the
  repository explicitly versions them.
- When generated artifacts are versioned, record the source and regeneration command.
- Review regenerated output for unexpected interface, frame, message, or configuration changes.

## Secrets and environment-specific values

- Do not commit credentials, tokens, private keys, passwords, or sensitive URLs.
- Avoid hard-coded user home paths, machine-specific absolute paths, device serial
  numbers, and fixed network addresses when they vary by deployment.
- Store genuinely variable values in documented configuration or environment variables.
- Keep safe defaults explicit and validate required environment-specific values at startup.
- Do not turn a stable implementation constant into configuration without a real variation need.
- Keep example configuration free of real credentials and private infrastructure details.

## Tests

- Test externally meaningful behavior, state transitions, boundary values, and failure paths.
- Keep each test focused on one behavior and use names that state the condition and expected result.
- Avoid tests that duplicate implementation details or assert incidental call structure.
- Prefer real pure logic, small fakes, or lightweight fixtures over broad mocking.
- Do not add mocks when a simple value, fake, or dependency boundary is sufficient.
- Do not weaken assertions, skip tests, or broaden tolerances only to make a failure pass.
- For ROS-facing behavior, test pure policy separately and add the smallest useful integration check.
- For hardware-sensitive behavior, identify a no-hardware, simulation, or dry-run check before real-device testing.
