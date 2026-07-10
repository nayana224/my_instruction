# Code Style Guide

## Goal

Code in this repository should be easy to read, review, test, and modify.

The preferred style is simple and explicit.

## Design principles

1. One function, one responsibility.
2. One file, one main reason to change.
3. Explicit names over clever abstractions.
4. Small changes over large rewrites.
5. Testable core logic separated from framework I/O.

## Function design

Prefer this structure:

1. Validate input.
2. Prepare data.
3. Execute one main action.
4. Return result or report error.

Avoid functions that do all of these at once:

- Read parameters
- Parse input
- Update state
- Publish ROS messages
- Write files
- Handle retries
- Log many unrelated events

## Naming

Use names that explain intent.

Good:

```python
load_robot_config()
validate_transition()
publish_mode_status()
```

Bad:

```python
process()
handle()
do_work()
manager()
```

Generic names are allowed only in very small scopes.

## Lambdas

Avoid lambdas by default.

Allowed:

```python
items.sort(key=lambda item: item.priority)
```

```cpp
std::sort(items.begin(), items.end(),
          [](const Item& a, const Item& b) {
            return a.priority < b.priority;
          });
```

Avoid:

```python
callback = lambda msg: self.parse_update_publish(msg)
```

Use a named function instead:

```python
def handle_status_message(self, msg: StatusMsg) -> None:
    ...
```

## Wrappers

Use wrappers only when they create a clear boundary.

Good wrapper reasons:

- Hide external API details
- Isolate hardware/ROS dependencies
- Improve testability
- Give domain meaning to repeated operations

Bad wrapper reasons:

- Add a new layer without simplifying anything
- Rename a function without changing abstraction level
- Hide side effects

## Comments

Comments should explain why, not repeat what.

Good:

```python
# The Jetson camera driver may publish one stale frame after startup.
# Ignore the first frame to avoid initializing the tracker with invalid depth.
```

Bad:

```python
# Increment count by one.
count += 1
```

## Error handling

- Fail early when input is invalid.
- Include enough context in error messages.
- Do not swallow exceptions silently.
- In ROS2 nodes, log errors with actionable context.

## C/C++ guidelines

- Prefer clear ownership and lifetime.
- Avoid raw owning pointers.
- Prefer RAII.
- Prefer `const` where it communicates intent.
- Avoid complex templates unless explicitly needed.
- Avoid macros unless there is no safer alternative.
- Keep header files focused on interfaces.
- Move implementation details to `.cpp` files when possible.

## Python guidelines

- Follow PEP 8 style.
- Use type hints for public functions and non-trivial internal functions.
- Prefer dataclasses for structured configuration/state.
- Avoid nested functions unless the scope is truly local and readability improves.
- Avoid complex lambdas. Lambdas are allowed only for simple key functions.
- Prefer explicit control flow over dense comprehensions when logic is non-trivial.
- Do not hide important side effects inside property methods.

## ROS2 guidelines

- Keep ROS I/O separate from core business logic when practical.
- Do not mix parameter loading, subscription callbacks, state transitions, and publishing in one large function.
- Keep callbacks short and delegate non-trivial logic to named functions.
- Use clear names for topics, services, parameters, and state transitions.
- Log important state changes.
- Avoid excessive logging inside high-frequency callbacks.
