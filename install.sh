#!/usr/bin/env bash

set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  bash install.sh [TARGET_DIR] [--force]

Copies AGENTS.md and docs/ into a project or workspace root.

Arguments:
  TARGET_DIR  Destination directory. Defaults to the current directory.
  --force     Replace an existing AGENTS.md and docs/ directory.
  -h, --help  Show this help.

Examples:
  bash install.sh ~/inpyo_ws/new_robot_ws
  bash install.sh . --force
EOF
}

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
target_dir="$(pwd)"
force=false
target_set=false

for argument in "$@"; do
  case "$argument" in
    --force)
      force=true
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    --*)
      echo "Error: unknown option: $argument" >&2
      usage >&2
      exit 2
      ;;
    *)
      if [[ "$target_set" == true ]]; then
        echo "Error: only one TARGET_DIR may be provided." >&2
        usage >&2
        exit 2
      fi
      target_dir="$argument"
      target_set=true
      ;;
  esac
done

if [[ ! -f "$script_dir/AGENTS.md" || ! -d "$script_dir/docs" ]]; then
  echo "Error: AGENTS.md or docs/ is missing from $script_dir" >&2
  exit 1
fi

mkdir -p -- "$target_dir"
target_dir="$(cd -- "$target_dir" && pwd)"

if [[ "$target_dir" == "$script_dir" ]]; then
  echo "Error: target directory is the instruction repository itself." >&2
  exit 1
fi

agents_target="$target_dir/AGENTS.md"
docs_target="$target_dir/docs"

if [[ "$force" != true ]]; then
  if [[ -e "$agents_target" || -e "$docs_target" ]]; then
    echo "Error: $target_dir already contains AGENTS.md or docs/." >&2
    echo "Review the existing files, then rerun with --force to replace them." >&2
    exit 1
  fi
fi

if [[ "$force" == true ]]; then
  rm -f -- "$agents_target"
  rm -rf -- "$docs_target"
fi

cp -- "$script_dir/AGENTS.md" "$agents_target"
cp -R -- "$script_dir/docs" "$docs_target"

cat <<EOF
Installed coding instructions into:
  $target_dir

Created:
  $agents_target
  $docs_target

Codex or GPT should read AGENTS.md first and open only the docs relevant to the current task.
EOF
