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

if [[ ! -f "${AOSP_ROOT}/${GOREECLOUD_OVERLAY_DESTINATION}/AndroidProducts.mk" ]]; then
  echo "GoreeCloud product overlay is not installed in the AOSP tree." >&2
  echo "Run scripts/install-goreecloud-overlay.sh first." >&2
  exit 65
fi

jobs="${JOBS:-$(getconf _NPROCESSORS_ONLN 2>/dev/null || printf '4')}"

cd "${AOSP_ROOT}"
# shellcheck disable=SC1091
source build/envsetup.sh
lunch "${GOREECLOUD_LUNCH_TARGET}"
m -j "${jobs}"
