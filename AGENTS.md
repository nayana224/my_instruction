# AGENTS.md

## Purpose

Keep changes simple, reviewable, and safe. Follow this file for every task and
open only the relevant guide in `docs/`.

## Priority

When rules conflict, follow this order:

1. Safety and correctness
2. Existing project conventions and public interfaces
3. This file
4. Relevant guides in `docs/`
5. Formatter defaults

## Work scope

- Make the smallest change that satisfies the request.
- Do not refactor, reformat, rename, or clean up unrelated code.
- Do not mix formatting-only changes with behavior changes.
- Preserve public ROS interfaces, file formats, frame names, package names, and
  installed paths unless all users are updated together.
- Before non-trivial or multi-file edits, state the plan and likely files. For a
  trivial localized edit, proceed directly and report the result.
- After editing, summarize changes, tests, behavior changes, and remaining risks.

## Simplicity

- Prefer explicit code with the fewest concepts.
- Add a function, class, wrapper, dataclass, type alias, macro, or abstraction
  only when it reduces total reasoning, testing, or change effort.
- Do not design for hypothetical future reuse.
- Prefer small obvious duplication over premature abstraction.
- Do not split cohesive code into tiny helpers only to reduce line count.
- Prefer module functions when no meaningful state or lifecycle exists.
- Avoid generic names and modules such as `Manager`, `Helper`, `Utils`, or
  `common.py` when a domain-specific name is available.

## Readability

- Keep the main control flow understandable in one pass.
- Avoid deep nesting, hidden side effects, clever expressions, and vague names.
- Separate ROS or hardware I/O from pure policy, conversion, and validation when
  the logic is non-trivial, reused, safety-relevant, or clearly benefits from an
  independent test boundary. Do not extract trivial pass-through helpers.
- Validate untrusted data once at a clear boundary. Do not repeat the same check
  throughout internal helpers.
- Type hints should clarify important interfaces, not annotate every local value.
- Avoid complex generic typing for one implementation or speculative reuse.

## Comments and documentation

- Keep identifiers, API names, ROS interfaces, units, frames, and technical terms
  in English.
- Write comments and docstrings in concise, natural Korean.
- Explain reasons, constraints, units, frames, ordering, workarounds, or safety
  implications. Do not repeat obvious code.
- Do not add comments or docstrings mechanically to every line or helper.
- Do not leave commented-out code. Update or remove stale comments.
- Follow `docs/python-docstring-style.md` for Python documentation.

## Safety and environment

- Keep command ownership, stop behavior, state transitions, and failure recovery
  explicit when the task involves stateful, asynchronous, motion, or hardware
  behavior.
- Follow `docs/safety.md` for motion, hardware, and safety-sensitive changes.
- Do not commit credentials, tokens, private keys, passwords, or sensitive URLs.
- Avoid hard-coded user paths, device serials, and network addresses when they
  vary by environment.
- Do not edit generated files directly. Edit the source schema, template, Xacro,
  message definition, or generator input.

## ROS and robot-description files

- Keep callbacks non-blocking and avoid excessive logging in high-rate paths.
- Do not hide remappings, controller selection, command ownership, or
  safety-relevant parameter overrides.
- Follow `docs/urdf-xacro-style.md` for URDF, Xacro, SDF, and related XML files.
- Treat frame transforms, joint limits, axes, mass, inertia, collision geometry,
  and plugin settings as behavior- and safety-sensitive data.
- Use SI units unless an external interface requires otherwise.

## Validation

- Run the most relevant checks already available in the project environment.
- Do not install tools, upgrade dependencies, or change the environment unless
  requested.
- Test meaningful behavior, boundaries, state transitions, and failure paths
  that are relevant to the changed code.
- Do not weaken assertions or tolerances only to make tests pass.
- Use simulation, dry-run, or no-hardware validation before real hardware when
  practical.
- Record checks that could not run and the remaining risk.

## Review requests

When asked to review code:

- Inspect before editing.
- Apply only the checks relevant to the changed files and behavior.
- Report actionable findings as Critical, Major, or Minor.
- Include exact paths, lines, or symbols and explain the concrete risk.
- Do not nitpick formatting already handled by tools.
- Follow `docs/code-review.md`.

## Guides

- `docs/code-style.md`: language, ROS 2, YAML, launch, and build rules
- `docs/code-review.md`: review checklist and output format
- `docs/python-docstring-style.md`: Korean comments and Python docstrings
- `docs/urdf-xacro-style.md`: URDF, Xacro, SDF, frames, and XML style
- `docs/safety.md`: robot and hardware safety changes
