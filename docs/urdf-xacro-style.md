# URDF, Xacro, and SDF Style Guide

Use this guide for `.urdf`, `.xacro`, `.sdf`, and related XML-based robot-description files.

## General structure

- Use two spaces for indentation and never use tabs.
- Put one element per line unless the element is short and has no child elements.
- Keep related `link`, `joint`, `transmission`, `gazebo`, and sensor blocks together.
- Order major sections consistently: properties and arguments, materials, macros, links, joints, transmissions, simulation-specific extensions.
- Avoid large monolithic files. Split by stable responsibility such as base, arm, gripper, sensor, control, and simulation.
- Do not split files only to reduce line count. A small robot description may remain in one file when it is easier to understand.

## Names and values

- Keep tag names, attribute names, link names, joint names, frame names, and Xacro identifiers in English.
- Use stable, domain-specific names such as `wrist_camera_link` and `tool_mount_joint`.
- Avoid vague names such as `link1`, `joint2`, `part`, or `temp` unless they match an external interface that cannot be changed.
- Preserve existing public link, joint, frame, controller, and transmission names unless all downstream users are updated.
- Use SI units: meters, radians, kilograms, seconds, and newtons unless an external format explicitly requires otherwise.
- Keep numeric precision only as high as the source measurement or calibration supports.
- Use `0` instead of long zero forms such as `0.000000` when precision is not meaningful.

## Tag and attribute formatting

Prefer short attributes on one line:

```xml
<link name="camera_link"/>
```

Split long elements so that each attribute is easy to scan:

```xml
<joint
  name="camera_mount_joint"
  type="fixed">
  <parent link="wrist_3_link"/>
  <child link="camera_link"/>
  <origin xyz="0 0 0.08" rpy="0 0 0"/>
</joint>
```

- Keep the identifying attributes such as `name` and `type` first.
- Keep related numeric attributes together, such as `xyz` with `rpy` and `lower` with `upper`.
- Use self-closing tags when an element has no child content.
- Do not compress nested robot structure into one long XML line.
- Attribute and block ordering is a consistency guideline, not a reason to reformat unrelated existing XML.
- Do not reorder attributes or blocks without a readability or consistency benefit.

## Origins, frames, and units

- Treat every `origin` as a frame transform. Confirm the parent frame and child frame before editing it.
- Keep `xyz` in meters and `rpy` in radians.
- Add a short Korean comment when a non-obvious offset, axis direction, calibration value, or frame convention must be preserved.
- State the physical reason or measurement source, not merely the numeric value.

Good:

```xml
<!-- 카메라 optical frame이 작업면을 향하도록 Y축 기준으로 90도 회전한다. -->
<origin xyz="0 0 0.08" rpy="0 1.570796 0"/>
```

Avoid:

```xml
<!-- origin을 설정한다. -->
<origin xyz="0 0 0.08" rpy="0 1.570796 0"/>
```

## Frame naming

- Use stable English frame names with a consistent `snake_case` convention.
- Use names that describe the physical or semantic frame, such as `camera_link`, `camera_color_optical_frame`, or `tool0`.
- Do not encode temporary implementation details, dates, or experiment numbers in public frame names.
- Preserve established TF frame names unless all publishers, consumers, launch files, configuration files, and saved data are updated together.
- Document non-obvious parent-child relationships, calibration offsets, and optical-frame conventions.
- Check that link names, TF frame names, sensor plugin frame settings, and controller references remain consistent.

## Comments

- Write comments in concise, natural Korean.
- Keep tag names, attribute names, link and joint names, units, frame names, plugin names, and established technical terms in English.
- Explain why a transform, limit, inertia, collision simplification, plugin setting, or workaround exists.
- Do not comment every `link`, `joint`, `visual`, `collision`, or `origin` block.
- Do not use comments as section labels when the surrounding structure is already obvious.
- Do not leave disabled XML or old robot-description blocks inside comments. Use version control instead.
- Update or remove comments whenever the related geometry, frame, limit, or plugin behavior changes.

## Xacro restraint

- Use a Xacro property when a value is shared, configurable, or has clear domain meaning.
- Do not replace every literal with a property.
- Use a macro only for real repeated structure or a stable component boundary.
- Do not create a macro for one trivial call site or only to shorten a file.
- Keep macro parameters minimal and domain-specific.
- Avoid passing long collections of loosely related parameters. Group them only when they represent a real component configuration.
- Avoid nested macro layers that require opening several files to understand one link or joint.
- Prefer direct XML over clever Xacro expressions when the direct form is easier to inspect.
- Avoid complex arithmetic and conditionals inside attributes. Move important calculations to clearly named properties.

## Generated robot-description files

- Edit the source Xacro, template, or generator input instead of generated URDF or SDF output.
- Do not commit generated robot-description files unless the repository explicitly treats them as versioned artifacts.
- Clearly mark generated files and record the command used to regenerate them when they must be versioned.
- Do not make a manual fix only in generated output; apply the fix to the source and regenerate.
- Review generated output for unresolved substitutions, duplicate names, invalid references, and unexpected link, joint, or frame changes.

## Geometry, inertia, and collision

- Keep `visual`, `collision`, and `inertial` origins intentionally aligned or document why they differ.
- Do not copy visual mesh geometry into collision geometry blindly. Prefer simple collision shapes when they preserve the required behavior.
- Treat mass, center of mass, and inertia values as safety- and simulation-sensitive data.
- Do not invent inertia values. Record the source or approximation method when values are not derived from CAD.
- Verify that inertia tensors are physically valid and expressed in the correct inertial frame.
- Preserve mesh scale and package paths unless the asset contract changes.

## Joints, limits, and axes

- Confirm the parent-child direction before changing a joint.
- Normalize joint axes and keep the axis convention explicit.
- Do not change joint type, limit, mimic relation, damping, friction, or safety-controller values without checking downstream control behavior.
- Keep joint limits consistent with the physical robot and controller configuration.
- Document non-obvious software limits that are intentionally narrower than hardware limits.

## Plugins and simulation extensions

- Keep Gazebo, Ignition/Gazebo Sim, ROS 2 control, and sensor plugin settings close to the component they affect when practical.
- Do not mix settings for multiple simulators without clear separation.
- Preserve plugin names, topic names, frame names, update rates, and interfaces unless downstream users are updated.
- Comment only non-default settings whose purpose or compatibility constraint is not obvious.

## Validation

For changed robot-description files, run the relevant checks when available:

```bash
xacro robot.urdf.xacro > /tmp/robot.urdf
check_urdf /tmp/robot.urdf
```

Also verify as applicable:

- the expanded XML contains the expected links and joints,
- TF parent-child relationships are correct,
- joint limits and axes are correct,
- meshes and package paths resolve,
- visual and collision geometry are placed correctly,
- inertial values do not cause simulation instability,
- `robot_state_publisher`, controllers, and simulator plugins still load.

Use the most relevant validation tools already available in the project environment. Do not install tools or change the environment automatically unless requested. If a validation tool cannot run, record what was not verified and the remaining risk.
