# AGENTS.md

## Purpose

Keep changes simple, reviewable, and safe. Treat this file as the map: follow
its core rules, then open only the `docs/` guide directly relevant to the task.

## Priority

When rules conflict, follow this order:

1. Safety and correctness
2. Existing project conventions and public interfaces
3. This file
4. Relevant guides in `docs/`
5. Formatter defaults

## Core workflow

- Inspect the relevant code and existing conventions before editing.
- Make the smallest change that satisfies the request.
- Do not refactor, rename, reformat, or clean up unrelated code.
- Preserve public interfaces, file formats, package names, frame names, and
  installed paths unless every affected user is updated together.
- For non-trivial or multi-file work, state the plan and likely files first.
- For a trivial localized edit, proceed directly.
- After editing, report changes, validation, behavior impact, and remaining risk.

## Scope and simplicity

- Prefer explicit code with the fewest concepts needed for the current task.
- Add abstractions only when they reduce total reasoning, testing, or change cost.
- Do not design for hypothetical future reuse.
- Keep cohesive code together; do not extract trivial pass-through helpers.
- Validate untrusted data once at a clear boundary.
- Do not edit generated files directly; edit their source or generator input.
- Do not commit credentials, tokens, private keys, passwords, or sensitive URLs.

## Large repositories

For multi-package repositories, cross-package changes, or unclear runtime paths,
follow `docs/repository-workflow.md` before editing.

- Identify the workspace, repository, affected package, runtime path,
  configuration, public interfaces, relevant tests, and excluded areas.
- Trace only as far as needed to establish the change scope.
- Do not scan or refactor the whole repository when a smaller dependency path is
  sufficient.

## Robotics and safety

- Keep command ownership, stop behavior, state transitions, and failure recovery
  explicit for motion, hardware, asynchronous, or stateful behavior.
- Preserve ROS topics, services, actions, parameters, QoS, TF frames, controller
  names, launch arguments, plugin names, and units unless intentionally changed.
- Keep callbacks non-blocking and avoid excessive logging in high-rate paths.
- Use SI units unless an external interface requires otherwise.
- Prefer simulation, dry-run, or no-hardware validation before real hardware.
- Follow `docs/safety.md` for motion, hardware, and safety-sensitive changes.
- Follow `docs/control-style.md` only for controllers, trajectory tracking,
  command generation, `ros2_control`, or timing-sensitive loops.
- Follow `docs/urdf-xacro-style.md` for URDF, Xacro, SDF, and related XML files.

## Code and documentation

- Follow existing project style before introducing a new convention.
- Keep identifiers, API names, ROS interfaces, units, frames, and technical terms
  in English.
- Write comments and docstrings in concise, natural Korean.
- Explain reasons, constraints, units, frames, ordering, workarounds, or safety
  implications; do not repeat obvious code.
- Follow `docs/code-style.md` for language, ROS 2, YAML, launch, and build rules.
- Follow `docs/python-docstring-style.md` for Python comments and docstrings.

## Validation

- Run the most relevant checks already available in the project environment.
- Start with the smallest useful validation scope and expand only when needed.
- Test relevant behavior, boundaries, state transitions, and failure paths.
- Do not weaken assertions or tolerances only to make tests pass.
- Do not install tools, upgrade dependencies, or change the environment unless
  requested.
- Record checks that could not run and the remaining risk.

## Commits and reviews

- When creating commits, follow `docs/commit-style.md` and use
  `<type>: <한글 요약>`.
- Keep one logical change per commit.
- When reviewing code, inspect before editing and follow `docs/code-review.md`.
- Report only actionable findings with concrete evidence and the smallest
  practical fix.

## Guide map

- `docs/code-style.md`: language, ROS 2, YAML, launch, and build rules
- `docs/code-review.md`: review checklist and output format
- `docs/commit-style.md`: lightweight commit message rules
- `docs/repository-workflow.md`: large and multi-package repository workflow
- `docs/control-style.md`: controller and timing-sensitive loop rules
- `docs/python-docstring-style.md`: Korean comments and Python docstrings
- `docs/urdf-xacro-style.md`: URDF, Xacro, SDF, frames, and XML style
- `docs/safety.md`: robot and hardware safety changes
