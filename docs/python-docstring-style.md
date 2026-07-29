# Python Comments and Docstrings

## Goal

Python comments and docstrings should help Korean-speaking maintainers understand
non-obvious intent without making the code noisy.

## Language

- Write comments and docstrings in concise, natural Korean.
- Keep identifiers, API names, library names, ROS interface names, units,
  coordinate frames, and established technical terms in English.
- Do not force Korean translations when the original technical term is clearer.

## Comments

Add a comment when it explains information that the code cannot express clearly:

- why a decision or workaround exists,
- an important assumption or constraint,
- required ordering or timing,
- units or coordinate frames,
- hardware or ROS compatibility behavior,
- or a safety implication.

Do not:

- comment every line or obvious operation,
- restate the code in Korean,
- use comments to compensate for vague names or excessive nesting,
- leave commented-out code,
- or keep stale comments after behavior changes.

```python
# D455 depth 값은 m 단위이므로 추가 변환 없이 사용한다.
depth_m = depth_image[row, column]
```

Avoid:

```python
# count를 1 증가시킨다.
count += 1
```

## Docstrings

Docstrings are useful for public interfaces, ROS-facing behavior, non-trivial
state transitions, safety-relevant side effects, and inputs whose units or
accepted forms are not obvious.

- Do not add docstrings mechanically to every function, method, or class.
- Short private helpers with clear names do not require docstrings.
- Prefer a one-line docstring when one sentence is sufficient.
- Do not repeat parameter names and types without adding semantic information.
- Document ranges, units, frames, ownership, side effects, exceptions, or
  blocking behavior when relevant.

```python
def transform_point(point: Point3D, transform: Transform) -> Point3D:
    """카메라 좌표계의 점을 로봇 base 좌표계로 변환한다."""
```

For a public function with non-obvious behavior:

```python
def publish_stop_command(reason: StopReason) -> None:
    """로봇에 안전 정지 명령을 발행한다.

    Args:
        reason: 안전 정지가 필요한 원인.

    Raises:
        RuntimeError: 정지 명령 발행에 실패한 경우.
    """
```

## TODO and workaround comments

- Avoid vague TODO comments such as `TODO: improve this`.
- State the concrete missing work and why it is not handled now.
- Include an issue number when the repository workflow supports it.
- Use `FIXME` for known incorrect behavior.
- Use `HACK` only for an unavoidable workaround and state when it can be removed.

```python
# TODO(#42): 센서 firmware가 SI 단위를 제공하면 이 변환을 제거한다.
```
