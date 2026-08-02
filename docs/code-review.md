# Code Review Guide

Use this guide when reviewing changes. Inspect before editing, and do not edit
files unless the review request explicitly asks for changes.

Apply only the checks relevant to the changed files and behavior. Do not force
ROS, hardware, launch, URDF, concurrency, or state-machine checks onto code that
does not involve those concerns.

## Review Priorities

Review in this order:

1. Correctness and public-interface compatibility
2. Runtime and hardware safety, when relevant
3. Validation and test evidence
4. Simplicity and maintainability
5. Readability and style

Do not focus on formatting that configured tools can check automatically.

## Core Review Checks

### Correctness and Compatibility

- Does the code handle expected, invalid, and boundary inputs that can actually
  occur?
- Does the change preserve public APIs, data formats, defaults, and downstream
  behavior, or update all affected users together?
- For stateful or asynchronous workflows, are repeated requests, cancellation,
  failure, recovery, and cleanup transitions valid?
- For ROS-facing changes, are topics, services, actions, parameters, QoS, TF
  frames, package names, executable names, and installed paths preserved or
  intentionally migrated?
- Could behavior differ on the target hardware, operating system, ROS
  distribution, middleware, dependency version, or deployment environment?

### Runtime and Safety

Apply this section only when the change touches motion, hardware, concurrency,
processes, timing-sensitive code, or safety-related state.

- Does any path publish motion commands, change command ownership, or alter stop
  behavior? If so, is the conservative failure path explicit?
- Are hardware, communication, tracking, localization, and autonomous-workflow
  failures handled safely?
- Are callbacks and high-rate loops non-blocking for their executor or control
  context?
- When shared mutable state exists, are executor behavior, callback groups,
  locking, ownership, and shutdown cleanup clear?
- Are waits, retries, locks, allocation, and logging appropriate for any
  real-time or high-rate path?
- Does the change follow the applicable rules in [`safety.md`](safety.md)?

### Validation and Tests

- Is there test coverage for changed non-trivial logic, conversions, boundaries,
  state transitions, and error paths when practical?
- Were the most relevant existing build, test, lint, simulation, dry-run, or
  integration checks run?
- If a check could not run, is the reason and remaining risk recorded?
- Is validation performed once at a clear trust boundary instead of repeated in
  every internal helper?
- Are defensive checks tied to states that can actually occur?
- Were project dependencies or tools left unchanged unless the task requested an
  environment change?

### Maintainability and Readability

- Can the main control flow be understood in one pass?
- Is each function responsible for one cohesive operation?
- Is non-trivial pure policy or conversion logic separated from I/O where that
  creates a useful test or reasoning boundary?
- Are names domain-specific and clear, including units where relevant?
- Are neighboring statements at a similar level of abstraction where practical?
- Does any wrapper, lambda, property, class, or abstraction hide side effects or
  add indirection without a useful boundary?
- Was code split only to satisfy a line-count guideline?
- Does the reader need to jump through several tiny helpers to understand one
  simple workflow?
- Was a function, class, interface, dataclass, enum, type alias, protocol,
  factory, registry, or wrapper introduced for one trivial call site or
  hypothetical future reuse?
- Would a small amount of direct, obvious code be easier to review and modify?

## File-Type-Specific Checks

Use only the subsections that match the changed files.

### Python and C/C++

- Do type hints clarify important public, shared, or non-trivial boundaries
  without making signatures harder to read?
- Are exceptions and error results handled with useful context?
- Is ownership and lifetime clear in C/C++?
- Are compiler warnings addressed rather than hidden?
- Are templates, metaprogramming, reflection, decorators, protocols, or generic
  mechanisms justified by a current need?

### YAML, Launch, and Build Files

- Are names, units, defaults, ranges, dependencies, and safety implications
  explicit?
- Does a launch argument represent a value that is genuinely expected to vary?
- Are parameters, remappings, namespaces, controller selection, and command
  ownership visible near the affected node?
- Are new dependencies directly required by current code or interfaces?
- Are target names, install paths, exports, executables, and package interfaces
  preserved or all downstream users updated?

### URDF, Xacro, and SDF

- Was the source Xacro or template changed instead of generated output?
- Are public link, joint, TF frame, controller, transmission, and plugin names
  preserved?
- Are parent-child relationships, transforms, axes, limits, mass, inertia,
  collision geometry, damping, friction, mimic relations, and SI units correct?
- Is each physical change supported by a model, measurement, manufacturer
  document, or clearly stated assumption?
- Was expanded output checked for unresolved substitutions, duplicate names,
  invalid references, and unexpected links, joints, or frames?
- Does the change follow [`urdf-xacro-style.md`](urdf-xacro-style.md)?

## Review Comment Structure

Each finding should distinguish:

1. **Observation:** what the code currently does.
2. **Risk:** the concrete correctness, safety, compatibility, or maintenance
   impact.
3. **Evidence:** the relevant path, line, symbol, control flow, test result, or
   interface.
4. **Suggestion:** the smallest practical change that addresses the risk.

Avoid preference-only comments such as "this feels cleaner" or "I would write
it differently" unless a concrete impact is identified.

## Finding Severity

- **Critical:** Can cause unsafe robot motion, data loss, a crash, a deadlock,
  or an unrecoverable workflow failure.
- **Major:** Can produce incorrect behavior, break an interface, leave a likely
  failure path unhandled, or make a current workflow unsafe or unreliable.
- **Minor:** Does not change behavior now, but causes a concrete clarity,
  consistency, or testability problem worth fixing.

Do not invent a severity when there is no meaningful issue. State explicitly
when no findings are identified and list any unverified risks or test gaps.

## Review Output Format

```text
Summary:
- Scope reviewed and verification performed.

Critical:
- [path:line or symbol] observation, concrete risk, evidence, suggested fix

Major:
- [path:line or symbol] observation, concrete risk, evidence, suggested fix

Minor:
- [path:line or symbol] observation, concrete impact, suggested fix

Validation gaps:
- Tests or runtime checks not run, reason, and remaining risk.

Suggested next step:
- Highest-value follow-up action.
```

Omit empty severity sections.

## Codex and GPT Review Prompt

```text
Review this code without editing files.

Follow AGENTS.md and apply only the sections of docs/code-review.md and
docs/code-style.md that are relevant to the changed files and behavior.

Review correctness and public-interface compatibility first. Check runtime or
hardware safety only when the change involves motion, hardware, concurrency,
timing-sensitive paths, or safety-related state. Then review validation, test
gaps, simplicity, maintainability, and readability.

Report only actionable findings as Critical / Major / Minor. For each finding,
include [path:line or symbol], observation, concrete risk, evidence, and the
smallest practical fix. Include a Validation gaps section. Do not edit files,
propose speculative architecture, or nitpick formatting handled by tools.
```
