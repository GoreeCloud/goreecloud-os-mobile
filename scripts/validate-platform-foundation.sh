#!/usr/bin/env bash
# GoreeCloud file version: 0.1.0-dev1
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd -- "${SCRIPT_DIR}/.." && pwd)"
# shellcheck disable=SC1091
source "${REPO_ROOT}/platform/aosp/android17-baseline.env"

fail() {
  echo "validation error: $*" >&2
  exit 1
}

required_files=(
  README.md
  SPECIFICATIONS.md
  FEATURES.md
  BENEFITS.md
  COMPETITIVE-OBJECTIVES.md
  FEATURE-ROADMAP.md
  platform/aosp/android17-baseline.env
  aosp-overlay/device/goreecloud/generic/AndroidProducts.mk
  aosp-overlay/device/goreecloud/generic/goreecloud_cf_arm64_phone.mk
  scripts/bootstrap-aosp.sh
  scripts/install-goreecloud-overlay.sh
  scripts/build-generic-arm64.sh
)

for relative_path in "${required_files[@]}"; do
  [[ -s "${REPO_ROOT}/${relative_path}" ]] || fail "missing or empty ${relative_path}"
done

[[ "${ANDROID_VERSION}" == "17" ]] || fail "ANDROID_VERSION must remain 17 for this foundation"
[[ "${ANDROID_API_LEVEL}" == "37" ]] || fail "ANDROID_API_LEVEL must remain 37 for this foundation"
[[ "${AOSP_MANIFEST_COMMIT}" =~ ^[0-9a-f]{40}$ ]] || fail "AOSP_MANIFEST_COMMIT is not a full Git SHA"
[[ "${AOSP_MANIFEST_REF}" == android-security-17.0.0_r1 ]] || fail "unexpected Android 17 baseline ref"
[[ "${GOREECLOUD_LUNCH_TARGET}" == goreecloud_cf_arm64_phone-trunk_staging-userdebug ]] || fail "unexpected GoreeCloud lunch target"

grep -Fq '$(call inherit-product, device/google/cuttlefish/vsoc_arm64/phone/aosp_cf.mk)' \
  "${REPO_ROOT}/aosp-overlay/device/goreecloud/generic/goreecloud_cf_arm64_phone.mk" \
  || fail "GoreeCloud product no longer inherits the expected ARM64 Cuttlefish product"

grep -Fq 'PRODUCT_NAME := goreecloud_cf_arm64_phone' \
  "${REPO_ROOT}/aosp-overlay/device/goreecloud/generic/goreecloud_cf_arm64_phone.mk" \
  || fail "GoreeCloud product name is missing"

for script in \
  scripts/bootstrap-aosp.sh \
  scripts/install-goreecloud-overlay.sh \
  scripts/build-generic-arm64.sh \
  scripts/validate-platform-foundation.sh; do
  bash -n "${REPO_ROOT}/${script}" || fail "shell syntax failed for ${script}"
done

if [[ "${1:-}" == "--verify-upstream" ]]; then
  command -v git >/dev/null 2>&1 || fail "git is required for upstream verification"
  peeled_ref="refs/tags/${AOSP_MANIFEST_REF}^{}"
  upstream_commit="$(git ls-remote "${AOSP_MANIFEST_URL}" "${peeled_ref}" | awk 'NR == 1 {print $1}')"
  [[ -n "${upstream_commit}" ]] || fail "could not resolve ${peeled_ref} from AOSP"
  [[ "${upstream_commit}" == "${AOSP_MANIFEST_COMMIT}" ]] \
    || fail "AOSP manifest tag no longer resolves to the recorded commit"
fi

printf 'GoreeCloud OS Mobile generic-platform foundation validation passed.\n'
