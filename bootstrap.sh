#!/usr/bin/env bash
set -euo pipefail

REPOSITORY_URL="https://github.com/nayana224/my_instruction.git"
REFERENCE="${MY_INSTRUCTION_REF:-main}"
TARGET_DIR="${1:-.}"

shift_count=0
if [[ $# -gt 0 ]]; then
  shift_count=1
fi

if [[ "$shift_count" -eq 1 ]]; then
  shift
fi

if ! command -v git >/dev/null 2>&1; then
  echo "오류: git이 설치되어 있지 않습니다." >&2
  exit 1
fi

TEMP_DIR="$(mktemp -d)"
cleanup() {
  rm -rf "$TEMP_DIR"
}
trap cleanup EXIT

echo "지침 저장소를 임시로 가져오는 중입니다..."
git clone --quiet --depth 1 --branch "$REFERENCE" "$REPOSITORY_URL" "$TEMP_DIR/my_instruction"

bash "$TEMP_DIR/my_instruction/install.sh" "$TARGET_DIR" "$@"

echo "완료: $(realpath "$TARGET_DIR")에 지침을 설치했습니다."
