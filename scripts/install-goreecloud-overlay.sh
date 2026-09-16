#!/usr/bin/env bash
# GoreeCloud file version: 0.1.0-dev1
set -euo pipefail

usage() {
  echo "Usage: $0 <aosp-source-root>" >&2
}

if [[ $# -ne 1 ]]; then
  usage
  exit 64
fi

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd -- "${SCRIPT_DIR}/.." && pwd)"
# shellcheck disable=SC1091
source "${REPO_ROOT}/platform/aosp/android17-baseline.env"

AOSP_ROOT="$(cd -- "$1" 2>/dev/null && pwd)" || {
  echo "AOSP source root does not exist: $1" >&2
  exit 66
}

if [[ ! -f "${AOSP_ROOT}/build/envsetup.sh" ]]; then
  echo "Not an initialized AOSP source tree: ${AOSP_ROOT}" >&2
  exit 65
fi

SOURCE_DIR="${REPO_ROOT}/${GOREECLOUD_OVERLAY_SOURCE}"
DEST_DIR="${AOSP_ROOT}/${GOREECLOUD_OVERLAY_DESTINATION}"

if [[ ! -d "${SOURCE_DIR}" ]]; then
  echo "Missing GoreeCloud overlay source: ${SOURCE_DIR}" >&2
  exit 66
fi

if [[ -e "${DEST_DIR}" ]]; then
  echo "Refusing to overwrite existing AOSP path: ${DEST_DIR}" >&2
  echo "Remove or reconcile that path explicitly before reinstalling the overlay." >&2
  exit 73
fi

mkdir -p "$(dirname -- "${DEST_DIR}")"
cp -a "${SOURCE_DIR}" "${DEST_DIR}"
printf 'Installed GoreeCloud generic product overlay at %s\n' "${DEST_DIR}"
