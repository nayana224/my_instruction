# Large Repository Workflow

## Scope

Use this guide only for multi-package repositories, cross-package changes, or
unclear execution paths. Do not use it for a small, well-localized edit whose
owner and callers are already obvious.

The goal is to reduce a large repository to the smallest dependency path that
can establish the requested change safely.

## 1. Establish the boundary

Before editing, identify:

- the repository root and workspace root,
- the current branch and existing local changes,
- the affected ROS package or component,
- the build system and target ROS distribution,
- and generated, vendored, or external code that should not be edited directly.

Do not assume the workspace and the repository are the same boundary. Do not
modify neighboring repositories merely because they are present in the same
`src/` directory.

## 2. Narrow the owner

Start from the user-visible interface, symbol, error, topic, controller, launch
argument, or configuration key mentioned in the request.

Trace only as far as needed through:

1. its definition,
2. direct callers or consumers,
3. configuration and launch wiring,
4. public interfaces,
5. and relevant tests.

Prefer targeted search by exact symbol, topic, parameter, executable, plugin,
or package name. Do not read or refactor the entire repository when a smaller
path can establish ownership and impact.

## 3. Trace the execution path

Confirm that the file being edited participates in the real runtime path.
Examples include:

```text
launch argument
  -> launch substitution
  -> parameter or YAML
  -> node or controller
  -> code that consumes the value
```

```text
plugin XML
  -> exported class
  -> loader or controller manager
  -> lifecycle or update method
```

```text
entry point
  -> main()
  -> node
  -> callback or action server
```

Do not change a similarly named file until the active path is confirmed.
Account for values that are overridden later by launch files, YAML, environment
settings, or hardware-specific configuration.

## 4. Separate interfaces from implementation

Treat the following as public or integration-sensitive unless proven otherwise:

- topics, services, actions, and message types,
- parameters, defaults, and YAML keys,
- TF frames, joint names, and controller names,
- launch arguments and executable names,
- plugin class names and exported libraries,
- package names, install paths, and saved-data formats.

For an interface change, find and update every direct user or preserve backward
compatibility. For an internal implementation change, avoid expanding the scope
to unrelated callers.

## 5. State the working scope

Before a non-trivial edit, briefly report:

- affected packages or components,
- likely files,
- the execution path being followed,
- interfaces that must remain stable,
- and important areas intentionally excluded.

This report should be short. It is not a request to map the entire repository.

## 6. Make the smallest coherent change

- Edit the owning layer rather than patching several downstream symptoms.
- Preserve compatibility code unless the request explicitly removes it.
- Do not reorganize package boundaries, launch structure, or naming while fixing
  a local behavior.
- Do not copy logic across packages when one clear owner already exists.
- Avoid changing vendored or generated files; change the upstream source or
  configuration instead.

## 7. Select validation by dependency radius

Use the narrowest validation that provides meaningful evidence:

1. inspect the diff and relevant interfaces,
2. run focused unit or static checks,
3. build or test the affected package,
4. build direct dependent packages when interfaces changed,
5. run a focused launch or integration smoke test,
6. and expand to the full workspace only when the change or project policy
   requires it.

Prefer existing project commands and CI configuration over invented validation
steps. Record which packages and paths were not validated.

## 8. Report evidence and limits

After editing, report:

- changed packages and files,
- the confirmed runtime path,
- preserved or changed interfaces,
- checks that ran and their results,
- checks that could not run,
- and uninspected areas that still carry risk.

Do not claim repository-wide safety from a package-level check.
