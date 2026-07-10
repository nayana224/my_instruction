# Codex Readability Rules

이 폴더는 Codex를 사용할 때 코드 가독성과 리뷰 가능성을 유지하기 위한 기본 규칙 파일 모음입니다.

## Files

- `AGENTS.md`: Codex가 따라야 할 최상위 작업 규칙
- `docs/code-style.md`: C/C++/Python/ROS2 코드 작성 원칙
- `docs/code-review.md`: 코드 리뷰 체크리스트와 리뷰 출력 형식

## How to use

repo 루트에 필요한 파일을 복사하세요.

```bash
cp AGENTS.md /path/to/your_repo/
cp -r docs /path/to/your_repo/
```

Codex에 코드 리뷰를 시킬 때는 다음처럼 요청하세요.

```text
Review this code without editing files.
Use AGENTS.md and docs/code-review.md.
Focus on readability, function size, unnecessary wrappers, complex lambdas, nested control flow, file responsibility, and ROS2 maintainability.
```
