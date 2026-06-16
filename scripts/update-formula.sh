#!/usr/bin/env bash
set -euo pipefail

APP="${1:?usage: update-formula.sh <app>}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if ! command -v gh >/dev/null 2>&1
then
  echo "error: gh CLI is required" >&2
  exit 1
fi

if ! command -v ruby >/dev/null 2>&1
then
  echo "error: ruby is required" >&2
  exit 1
fi

exec ruby "${SCRIPT_DIR}/update-formula.rb" "${APP}"
