# Codex Readability Rules

이 폴더는 Codex를 사용할 때 코드 가독성과 리뷰 가능성을 유지하기 위한 기본 규칙 파일 모음입니다.

## Files

- `AGENTS.md`: Codex가 따라야 할 최상위 작업 규칙
- `docs/code-style.md`: C/C++/Python/ROS2 코드 작성 원칙
- `docs/code-review.md`: 코드 리뷰 체크리스트와 리뷰 출력 형식
- `docs/python-docstring-style.md`: 한글 주석과 Python docstring 작성 원칙
- `docs/urdf-xacro-style.md`: URDF/Xacro/SDF 태그, 구조, 주석 작성 원칙
- `docs/safety.md`: 로봇 명령과 안전 관련 변경 검토 원칙

## How to use

repo 루트에 필요한 파일을 복사하세요.

```bash
cp AGENTS.md /path/to/your_repo/
cp -r docs /path/to/your_repo/
```

코드 식별자는 영어로 유지하고, 주석과 docstring은 짧고 자연스러운 한글로 작성합니다. API 이름, ROS interface, 단위, 좌표계, 기술 용어는 원문을 유지합니다.

URDF, Xacro, SDF 같은 XML 기반 로봇 설명 파일은 태그 정렬, `origin`, frame, 단위, joint limit, inertia, Xacro macro 사용 기준을 위해 `docs/urdf-xacro-style.md`를 함께 적용합니다.

Codex에 코드 리뷰를 시킬 때는 다음처럼 요청하세요.

```text
Review this code without editing files.
Use AGENTS.md and docs/code-review.md.
Focus on readability, function size, unnecessary wrappers, complex lambdas,
nested control flow, file responsibility, comment quality, URDF/Xacro structure,
and ROS2 maintainability.
```
