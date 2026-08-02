# Codex Readability Rules

Codex와 GPT가 작은 범위에서 읽기 쉽고 안전한 코드를 작성하도록 돕는 규칙 모음입니다.

이 저장소는 모든 규칙을 매 작업마다 강제로 적용하는 체크리스트가 아닙니다.
`AGENTS.md`는 항상 따르고, `docs/`에서는 현재 작업과 직접 관련된 문서와 절만 확인합니다.

## 권장 설치 방법

이 저장소는 홈 디렉터리 아래에 한 번만 clone해 두고, 새 workspace 또는 프로젝트를 만들 때 `install.sh`를 실행하는 방식을 권장합니다.

### 1. 최초 한 번만 clone

```bash
mkdir -p ~/.local/share

git clone \
  https://github.com/nayana224/my_instruction.git \
  ~/.local/share/my_instruction
```

이미 clone했다면 최신 내용만 갱신합니다.

```bash
git -C ~/.local/share/my_instruction pull --ff-only
```

### 2. 새 workspace에 적용

workspace 루트를 지정합니다.

```bash
bash ~/.local/share/my_instruction/install.sh \
  ~/inpyo_ws/new_robot_ws
```

현재 디렉터리에 적용할 때는 다음처럼 실행합니다.

```bash
cd ~/inpyo_ws/new_robot_ws
bash ~/.local/share/my_instruction/install.sh .
```

설치 결과는 다음과 같습니다.

```text
new_robot_ws/
├── AGENTS.md
└── docs/
    ├── code-style.md
    ├── code-review.md
    ├── python-docstring-style.md
    ├── urdf-xacro-style.md
    └── safety.md
```

기존 `AGENTS.md` 또는 `docs/`가 있으면 installer는 덮어쓰지 않고 중단합니다. 내용을 확인한 뒤 이 지침으로 교체하려는 경우에만 `--force`를 사용합니다.

```bash
bash ~/.local/share/my_instruction/install.sh \
  ~/inpyo_ws/new_robot_ws \
  --force
```

`--force`는 대상 workspace의 기존 `AGENTS.md`와 `docs/`를 제거한 뒤 교체하므로, 프로젝트별 규칙을 작성해 두었다면 먼저 백업하거나 병합해야 합니다.

### 한 번만 임시 clone해서 적용

홈 디렉터리에 저장소를 유지하지 않으려면 다음처럼 사용할 수 있습니다.

```bash
tmp_dir="$(mktemp -d)"
git clone --depth 1 \
  https://github.com/nayana224/my_instruction.git \
  "$tmp_dir/my_instruction"
bash "$tmp_dir/my_instruction/install.sh" ~/inpyo_ws/new_robot_ws
rm -rf "$tmp_dir"
```

## Codex와 GPT 사용 원칙

Codex나 GPT에는 다음 순서로 참조하도록 요청합니다.

1. 먼저 프로젝트 자체의 구조, 환경, 기존 인터페이스를 확인합니다.
2. `AGENTS.md`의 핵심 규칙을 적용합니다.
3. 현재 작업에 필요한 `docs/` 문서와 절만 확인합니다.
4. 관련 없는 리팩터링이나 미래 대비 구조를 추가하지 않습니다.
5. 변경 후 실행한 검증, 실행하지 못한 검증, 남은 위험을 보고합니다.

예를 들어 순수 Python 함수 수정에는 ROS, launch, URDF, hardware 항목을 적용할 필요가 없습니다. 반대로 motion command, controller, URDF, TF를 변경할 때는 관련 안전 문서를 반드시 확인합니다.

## 핵심 원칙

- 요청한 범위만 작게 수정
- 불필요한 추상화와 미래 대비 코드 금지
- 단순한 adapter와 callback을 억지로 여러 helper로 분리하지 않기
- 코드 식별자는 영어, 주석과 docstring은 간결한 한글
- ROS interface, TF frame, 단위, 안전 동작 보존
- 작업과 관련된 검증만 우선 수행하고 남은 위험 보고

## 문서

- `AGENTS.md`: 모든 작업에 적용되는 핵심 규칙
- `docs/code-style.md`: Python, C/C++, ROS 2, YAML, launch, build 규칙
- `docs/code-review.md`: 관련 항목만 적용하는 리뷰 체크리스트
- `docs/python-docstring-style.md`: 한글 주석과 docstring
- `docs/urdf-xacro-style.md`: URDF, Xacro, SDF, XML 태그와 frame
- `docs/safety.md`: 로봇과 하드웨어 안전 변경

## 기본 요청 예시

```text
이 저장소의 AGENTS.md를 먼저 따라줘.
현재 작업에 직접 관련된 docs 문서와 절만 확인해줘.
요청한 범위 밖의 리팩터링이나 추상화는 하지 마.
변경 후 실행한 테스트, 실행하지 못한 검증, 남은 위험을 알려줘.
```

작은 수정:

```text
AGENTS.md를 따라 이 파일의 오류만 최소한으로 수정해줘.
단순한 변경이면 별도 설계나 helper를 추가하지 마.
```

코드 리뷰:

```text
AGENTS.md와 docs/code-review.md를 따라 리뷰해줘.
변경된 파일과 동작에 관련된 체크만 적용하고 파일은 수정하지 마.
실제 위험이 있는 항목만 근거와 가장 작은 수정안과 함께 보고해줘.
```

로봇 또는 하드웨어 변경:

```text
AGENTS.md와 docs/safety.md를 따라 수정해줘.
ROS interface, TF frame, 단위, command ownership, safe-stop 동작을 보존해줘.
실제 하드웨어 전에 가능한 simulation 또는 dry-run 검증을 우선해줘.
```
