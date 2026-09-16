#!/usr/bin/env bash
# GoreeCloud file version: 0.1.0-dev1
set -euo pipefail

usage() {
  cat >&2 <<'EOF'
Usage: scripts/bootstrap-aosp.sh <aosp-source-root> [--init-only]

Initializes the pinned Android 17 AOSP manifest. By default it also syncs the
source tree and installs the GoreeCloud generic product overlay. --init-only
stops after manifest initialization and pin verification.
EOF
}

if [[ $# -lt 1 || $# -gt 2 ]]; then
  usage
  exit 64
fi

AOSP_ROOT="$1"
MODE="${2:-}"
if [[ -n "${MODE}" && "${MODE}" != "--init-only" ]]; then
  usage
  exit 64
fi

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd -- "${SCRIPT_DIR}/.." && pwd)"
# shellcheck disable=SC1091
source "${REPO_ROOT}/platform/aosp/android17-baseline.env"

for command_name in git repo; do
  command -v "${command_name}" >/dev/null 2>&1 || {
    echo "Required command not found: ${command_name}" >&2
    exit 69
  }
done

mkdir -p "${AOSP_ROOT}"
AOSP_ROOT="$(cd -- "${AOSP_ROOT}" && pwd)"

if [[ -e "${AOSP_ROOT}/.repo" ]]; then
  echo "Refusing to reinitialize an existing repo workspace: ${AOSP_ROOT}" >&2
  exit 73
fi

(
  cd "${AOSP_ROOT}"
  repo init -u "${AOSP_MANIFEST_URL}" -b "${AOSP_MANIFEST_REF}"

  actual_manifest_commit="$(git -C .repo/manifests rev-parse HEAD)"
  if [[ "${actual_manifest_commit}" != "${AOSP_MANIFEST_COMMIT}" ]]; then
    echo "Manifest pin mismatch." >&2
    echo "Expected: ${AOSP_MANIFEST_COMMIT}" >&2
    echo "Actual:   ${actual_manifest_commit}" >&2
    exit 65
  fi

  printf 'Verified AOSP manifest %s at %s\n' \
    "${AOSP_MANIFEST_REF}" "${AOSP_MANIFEST_COMMIT}"

  if [[ "${MODE}" == "--init-only" ]]; then
    exit 0
  fi

  jobs="${JOBS:-$(getconf _NPROCESSORS_ONLN 2>/dev/null || printf '4')}"
  repo sync -c -j "${jobs}"
)

"${SCRIPT_DIR}/install-goreecloud-overlay.sh" "${AOSP_ROOT}"
printf 'AOSP source synchronization and GoreeCloud overlay installation completed.\n'
printf 'Next: %s %q\n' "${SCRIPT_DIR}/build-generic-arm64.sh" "${AOSP_ROOT}"
