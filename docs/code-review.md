# Code Review Guide

Use this guide when reviewing changes.

## Review priorities

Review in this order:

1. Correctness
2. Runtime safety
3. Simplicity
4. Maintainability
5. Testability
6. Style

Do not focus on formatting unless formatters cannot handle it.

## Review checklist

### Correctness

- Does the code handle expected inputs?
- Does it handle invalid inputs?
- Are edge cases covered?
- Are state transitions valid?
- Could this fail on Jetson or a different ROS2 environment?

### Readability

- Can the main flow be understood in one pass?
- Are functions small and focused?
- Are names domain-specific and clear?
- Is there unnecessary nesting?
- Is any lambda or wrapper hiding important behavior?

### Architecture

- Is core logic separated from ROS I/O?
- Are hardware/framework dependencies isolated?
- Is the file responsible for too many things?
- Would a new developer know where to make a related change?

### Python

- Are type hints present where useful?
- Are exceptions handled explicitly?
- Are dataclasses/config objects used where they simplify parameters?
- Are comprehensions simple enough to read?

### C/C++

- Is ownership clear?
- Are references/pointers safe?
- Are headers minimal?
- Are templates/macros avoided unless necessary?
- Are lambdas short and local?

### ROS2

- Are topic/service/parameter names clear?
- Are callbacks short?
- Is high-frequency logging avoided?
- Are launch/config changes documented?
- Are parameters validated?

## Output format for reviews

Use this format:

```text
Summary:
- ...

Critical:
- [file:function] issue, risk, suggested fix

Major:
- [file:function] issue, risk, suggested fix

Minor:
- [file:function] issue, suggested fix

Suggested next step:
- ...
```

## Codex review prompt

```text
Review this code without editing files.

Use docs/code-review.md.
Focus on:
- readability
- function size
- unnecessary wrappers
- complex lambdas
- nested control flow
- file responsibility
- ROS2 maintainability

Report issues as Critical / Major / Minor.
Do not nitpick formatting handled by tools.
```
