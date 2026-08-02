# Codex Readability Rules

Codex와 GPT가 ROS 2와 로봇 프로젝트를 읽기 쉽고 안전하게 수정하도록 돕는 지침 모음입니다.

`AGENTS.md`는 항상 따르고, `docs/`에서는 현재 작업과 직접 관련된 문서만 확인합니다. 모든 문서를 매번 읽는 방식이 아닙니다.

## 가장 쉬운 설치 방법

새 workspace로 이동합니다.

```bash
cd ~/inpyo_ws/new_robot_ws
```

아래 명령어 한 줄을 실행합니다.

```bash
curl -fsSL \
  https://raw.githubusercontent.com/nayana224/my_instruction/main/bootstrap.sh \
  | bash
```

설치 후 다음 파일이 생깁니다.

```text
new_robot_ws/
├── AGENTS.md
└── docs/
    ├── code-style.md
    ├── code-review.md
    ├── commit-style.md
    ├── repository-workflow.md
    ├── control-style.md
    ├── python-docstring-style.md
    ├── urdf-xacro-style.md
    └── safety.md
```

이제 Codex나 GPT에게 다음처럼 요청합니다.

```text
이 workspace의 AGENTS.md를 먼저 따라줘.
현재 작업에 직접 관련된 docs 문서만 확인해줘.
```

### 기존 지침 교체

기존 `AGENTS.md` 또는 `docs/`가 있으면 기본 설치는 덮어쓰지 않습니다. 완전히 교체할 때만 다음 명령을 사용합니다.

```bash
curl -fsSL \
  https://raw.githubusercontent.com/nayana224/my_instruction/main/bootstrap.sh \
  | bash -s -- . --force
```

`--force`는 기존 지침을 삭제하고 새 버전으로 교체합니다. 프로젝트별 규칙을 직접 작성했다면 먼저 백업하거나 병합합니다.

## 어떤 문서를 읽는가

| 작업 | 확인할 문서 |
|---|---|
| 작은 코드 수정 | `AGENTS.md`, 필요한 `code-style.md` 절 |
| 코드 리뷰 | `code-review.md` |
| 커밋 생성 | `commit-style.md` |
| 여러 ROS package가 연결된 대형 저장소 | `repository-workflow.md` |
| PID, trajectory tracking, `ros2_control` 등 제어 코드 | `control-style.md`, `safety.md` |
| URDF, Xacro, SDF | `urdf-xacro-style.md`, 필요 시 `safety.md` |
| motion command와 실제 하드웨어 | `safety.md` |

순수 Python 함수 수정에는 ROS controller나 URDF 지침을 적용하지 않습니다. 반대로 UR5e driver, MDBOT bringup, MoveIt, Nav2처럼 package·launch·config·controller가 연결된 작업에서는 `repository-workflow.md`로 영향 범위를 먼저 좁힙니다.

## 핵심 원칙

- 요청한 범위만 작게 수정
- 관련 없는 리팩터링과 미래 대비 구조 금지
- 대형 저장소에서는 package와 실제 실행 경로를 먼저 확인
- ROS interface, TF frame, controller 이름, 단위, 안전 동작 보존
- 제어 코드에서는 시간, frame, limit, timeout, command ownership 확인
- 실제 하드웨어 전에 simulation 또는 dry-run 우선
- 커밋은 `<type>: <한글 요약>` 형식
- 실행한 검증, 실행하지 못한 검증, 남은 위험 보고

## 요청 예시

일반 수정:

```text
AGENTS.md를 따라 요청한 오류만 최소한으로 수정해줘.
관련 없는 리팩터링은 하지 말고, 변경 후 검증 결과와 남은 위험을 알려줘.
```

대형 ROS 저장소:

```text
AGENTS.md와 docs/repository-workflow.md를 따라 작업해줘.
먼저 관련 package, 실행 경로, interface, config, test 범위를 좁힌 뒤 수정해줘.
저장소 전체를 불필요하게 정리하지 마.
```

제어 코드:

```text
AGENTS.md, docs/control-style.md, docs/safety.md를 따라 수정해줘.
control period, dt, frame, limit, timeout, command ownership, safe-stop을 확인해줘.
실제 하드웨어 전에 가능한 simulation 검증을 먼저 해줘.
```

코드 리뷰:

```text
AGENTS.md와 docs/code-review.md를 따라 리뷰해줘.
변경과 관련된 항목만 확인하고 실제 위험이 있는 내용만 보고해줘.
```

## 직접 저장소를 보관하는 방법

지침을 자주 수정할 때만 홈 디렉터리에 clone해 둡니다.

```bash
mkdir -p ~/.local/share
git clone \
  https://github.com/nayana224/my_instruction.git \
  ~/.local/share/my_instruction
```

최신화:

```bash
git -C ~/.local/share/my_instruction pull --ff-only
```

새 workspace에 적용:

```bash
bash ~/.local/share/my_instruction/install.sh ~/inpyo_ws/new_robot_ws
```
