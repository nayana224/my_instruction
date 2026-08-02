# Robot Control Code Guide

## Scope

Use this guide only for feedback controllers, trajectory tracking, command
generation, `ros2_control` controllers, force or impedance control, and other
timing-sensitive control loops. Do not apply it to unrelated application,
visualization, documentation, or data-processing code.

Follow [`safety.md`](safety.md) whenever the change can publish motion commands,
change command ownership, or alter stop behavior.

## Time and update period

- Make the intended control rate and time source explicit.
- Use measured or framework-provided `dt` when the algorithm depends on elapsed
  time. Do not assume timer configuration equals actual execution period.
- Handle non-positive, non-finite, unexpectedly large, or discontinuous `dt`
  conservatively.
- Do not mix ROS time, simulation time, steady time, and wall time without an
  explicit conversion and reason.
- Detect and report control-loop overruns when timing is safety- or
  performance-relevant.

## Units, frames, and signs

- State the unit and coordinate frame of controller inputs, errors, state, and
  outputs when they are not obvious from the interface.
- Keep degree/radian, position/velocity, linear/angular, and body/world-frame
  conversions at clear boundaries.
- Verify quaternion ordering, angle wrapping, joint-axis direction, and sign
  conventions before tuning gains or reversing commands.
- Prefer names that expose ambiguous units or frames, such as
  `yaw_error_rad` or `velocity_command_base_mps`.

## Input validity and freshness

Before using measurements or estimates, consider:

- finite numeric values,
- timestamp age and ordering,
- transform availability at the relevant timestamp,
- sensor or estimator dropout,
- and physically implausible jumps.

Define the safe behavior for stale or invalid state. Do not continue reusing an
old observation or command without a documented timeout policy.

## Limits and command shaping

- Apply position, velocity, acceleration, jerk, effort, workspace, and hardware
  limits that are relevant to the commanded interface.
- Keep the order of filtering, rate limiting, saturation, and final validation
  explicit.
- Check the final command for `NaN`, infinity, invalid frames, and out-of-range
  values before publication or hardware write.
- Do not weaken URDF, controller, or hardware limits to hide unstable behavior.
- When limiting one quantity can invalidate another constraint, test the combined
  behavior rather than each clamp in isolation.

## Controller state

For stateful controllers such as PID or observers:

- define initialization and reset conditions,
- prevent or handle integral windup when outputs saturate,
- make derivative filtering and derivative-on-error or measurement choices
  explicit when relevant,
- avoid carrying stale integrator or filter state across incompatible mode
  changes,
- and document parameter units and expected operating range.

Do not add advanced control structure when a simple controller satisfies the
measured requirement. Do not tune by arbitrary gain changes without recording
the observed behavior and test conditions.

## Command ownership and mode transitions

- Ensure only the intended source owns each command interface.
- Make activation, deactivation, cancellation, timeout, and shutdown behavior
  explicit.
- During controller or mode switching, define the initial setpoint and prevent
  discontinuous commands where practical.
- If switching fails or state is uncertain, prefer a defined hold or stop state
  over silently continuing with the previous command.
- Do not assume controller-manager state, action success, or heartbeat alone
  proves that commanded motion is safe.

## High-rate and real-time paths

For controller `update()` methods and other high-rate paths:

- avoid blocking I/O, sleeps, service calls, action waits, and unbounded retries,
- avoid excessive logging and repeated allocations where timing matters,
- keep locks short and do not hold them across external calls,
- bound work per cycle,
- and move diagnostics or slow computation out of the critical path when
  practical.

Do not claim real-time safety unless the complete execution path, memory
behavior, synchronization, and dependencies have been verified.

## Validation

Select checks relevant to the changed controller. Useful cases include:

- zero error and steady state,
- large initial error or setpoint step,
- saturation and anti-windup,
- stale, delayed, missing, or malformed state,
- irregular `dt` and control-loop overrun,
- repeated start, stop, reset, and mode transitions,
- cancellation and shutdown,
- and command ownership conflicts.

When performance matters, report suitable measures such as tracking error,
overshoot, settling behavior, command saturation, and loop-period jitter. Do not
require every metric for every controller.

Validate in the safest practical order:

1. pure calculations and boundary tests,
2. package build and focused tests,
3. no-hardware or simulation execution,
4. reduced-speed operation in a controlled workspace,
5. and normal operation only after earlier checks pass.

Record controller parameters, relevant rates, test conditions, and remaining
hardware risk so results can be reproduced.
