# Codex Readability Rules

Codex가 작은 범위에서 읽기 쉽고 안전한 코드를 작성하도록 돕는 규칙 모음입니다.

## 적용

프로젝트 루트에 복사합니다.

```bash
cp AGENTS.md /path/to/your_repo/
cp -r docs /path/to/your_repo/
```

Codex는 먼저 `AGENTS.md`를 읽고, 작업에 필요한 세부 문서만 확인하면 됩니다.

## 핵심 원칙

- 요청한 범위만 작게 수정
- 불필요한 추상화와 미래 대비 코드 금지
- 코드 식별자는 영어, 주석과 docstring은 간결한 한글
- ROS interface, TF frame, 단위, 안전 동작 보존
- 실행한 검증과 남은 위험 보고

## 문서

- `AGENTS.md`: 모든 작업에 적용되는 핵심 규칙
- `docs/code-style.md`: Python, C/C++, ROS 2, YAML, launch, build 규칙
- `docs/code-review.md`: 리뷰 체크리스트
- `docs/python-docstring-style.md`: 한글 주석과 docstring
- `docs/urdf-xacro-style.md`: URDF, Xacro, SDF, XML 태그와 frame
- `docs/safety.md`: 로봇과 하드웨어 안전 변경

## 요청 예시

```text
AGENTS.md를 따라 이 파일만 수정해줘.
관련 없는 코드는 정리하지 마.
변경 후 실행한 테스트와 남은 위험을 알려줘.
```

코드 리뷰:

```text
AGENTS.md와 docs/code-review.md를 따라 리뷰해줘.
파일은 수정하지 말고, 실제 위험이 있는 항목만 보고해줘.
```
