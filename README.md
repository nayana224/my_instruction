# Codex Readability Rules

Codex와 GPT가 작은 범위에서 읽기 쉽고 안전한 코드를 작성하도록 돕는 규칙 모음입니다.

이 저장소는 모든 규칙을 매 작업마다 강제로 적용하는 체크리스트가 아닙니다.
`AGENTS.md`는 항상 따르고, `docs/`에서는 현재 작업과 직접 관련된 문서와 절만 확인합니다.

## 가장 쉬운 설치 방법

새 workspace를 만든 뒤 그 폴더로 이동합니다.

```bash
cd ~/inpyo_ws/new_robot_ws
```

그다음 아래 명령어 한 줄만 실행합니다.

```bash
curl -fsSL \
  https://raw.githubusercontent.com/nayana224/my_instruction/main/bootstrap.sh \
  | bash
```

설치가 끝나면 현재 workspace에 다음 파일이 생깁니다.

```text
new_robot_ws/
├── AGENTS.md
└── docs/
    ├── code-style.md
    ├── code-review.md
    ├── commit-style.md
    ├── python-docstring-style.md
    ├── urdf-xacro-style.md
    └── safety.md
```

이제 Codex나 GPT에게 다음처럼 요청하면 됩니다.

```text
이 workspace의 AGENTS.md를 먼저 따라줘.
현재 작업에 직접 관련된 docs 문서와 절만 확인해줘.
```

### 기존 지침을 새 버전으로 교체

이미 `AGENTS.md` 또는 `docs/`가 있으면 기본 설치는 덮어쓰지 않고 중단합니다.
기존 내용을 확인한 뒤 완전히 교체하려는 경우에만 다음 명령어를 사용합니다.

```bash
curl -fsSL \
  https://raw.githubusercontent.com/nayana224/my_instruction/main/bootstrap.sh \
  | bash -s -- . --force
```

`--force`는 현재 workspace의 기존 `AGENTS.md`와 `docs/`를 제거한 뒤 교체합니다.
프로젝트별 규칙을 직접 작성해 두었다면 먼저 백업하거나 병합해야 합니다.

## 명령어가 실제로 하는 일

위 한 줄 명령어는 내부적으로만 다음 작업을 수행합니다.

1. `my_instruction` 저장소를 임시 폴더에 clone합니다.
2. `AGENTS.md`와 `docs/`를 현재 workspace에 복사합니다.
3. 임시로 clone한 폴더를 자동으로 삭제합니다.

따라서 workspace 안에 `my_instruction` 저장소나 별도의 `.git` 폴더가 남지 않습니다.

## 저장소를 직접 보관하는 방법

지침 내용을 자주 직접 수정하거나 확인하려는 경우에만 저장소를 홈 디렉터리에 clone해 둡니다.
일반적인 사용에는 위의 한 줄 설치 방법이 더 쉽습니다.

최초 한 번:

```bash
mkdir -p ~/.local/share

git clone \
  https://github.com/nayana224/my_instruction.git \
  ~/.local/share/my_instruction
```

최신 버전 받기:

```bash
git -C ~/.local/share/my_instruction pull --ff-only
```

새 workspace에 적용:

```bash
bash ~/.local/share/my_instruction/install.sh ~/inpyo_ws/new_robot_ws
```

## Codex와 GPT 사용 원칙

Codex나 GPT에는 다음 순서로 참조하도록 요청합니다.

1. 먼저 프로젝트 자체의 구조, 환경, 기존 인터페이스를 확인합니다.
2. `AGENTS.md`의 핵심 규칙을 적용합니다.
3. 현재 작업에 필요한 `docs/` 문서와 절만 확인합니다.
4. 관련 없는 리팩터링이나 미래 대비 구조를 추가하지 않습니다.
5. 변경 후 실행한 검증, 실행하지 못한 검증, 남은 위험을 보고합니다.

예를 들어 순수 Python 함수 수정에는 ROS, launch, URDF, hardware 항목을 적용할 필요가 없습니다. 반대로 motion command, controller, URDF, TF를 변경할 때는 관련 안전 문서를 반드시 확인합니다.

커밋을 만들 때만 `docs/commit-style.md`를 확인합니다. 기본 형식은 다음과 같습니다.

```text
feat: 그리퍼 힘 제한 설정 추가
fix: 카메라 재연결 상태 초기화
```

## 핵심 원칙

- 요청한 범위만 작게 수정
- 불필요한 추상화와 미래 대비 코드 금지
- 단순한 adapter와 callback을 억지로 여러 helper로 분리하지 않기
- 코드 식별자는 영어, 주석과 docstring은 간결한 한글
- ROS interface, TF frame, 단위, 안전 동작 보존
- 커밋은 `<type>: <한글 요약>` 형식으로 작성
- 작업과 관련된 검증만 우선 수행하고 남은 위험 보고

## 문서

- `AGENTS.md`: 모든 작업에 적용되는 핵심 규칙
- `docs/code-style.md`: Python, C/C++, ROS 2, YAML, launch, build 규칙
- `docs/code-review.md`: 관련 항목만 적용하는 리뷰 체크리스트
- `docs/commit-style.md`: 간단한 커밋 메시지 규칙
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
