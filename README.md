---
title: "GoreeCloud OS Mobile"
version: "0.1.0-dev1"
status: "Development / Bring-up"
---

# GoreeCloud OS Mobile

GoreeCloud OS Mobile is the GoreeCloud mobile operating-system project. Its strategic platform track targets Android 17 / AOSP / API 37, while the current physical qualification baseline remains the OnePlus Nord N200 (`dre`, DE2117) on LineageOS 23.2 / Android 16.

## Current repository state

Development is in Phase 0 / generic-platform foundation work. The current source includes an existing GoreeCloud wallpaper partner module plus a Development Android 17 foundation consisting of a pinned AOSP baseline, a GoreeCloud ARM64 Cuttlefish product overlay, guarded bootstrap/build scripts, and repository-level validation.

No full GoreeCloud Android 17 image has yet been verified as built or booted from this repository. The generic target does not establish Android 17 support for `dre`, production signing, GoreeCloud-owned OTA, bootloader relock safety, Release Candidate status, or Stable status.

## Android 17 generic target

The source baseline and product contract are defined in:

- `platform/aosp/android17-baseline.env`
- `aosp-overlay/device/goreecloud/generic/`
- `scripts/bootstrap-aosp.sh`
- `scripts/build-generic-arm64.sh`
- `scripts/validate-platform-foundation.sh`

Development target:

```text
goreecloud_cf_arm64_phone-trunk_staging-userdebug
```

See `docs/development/ANDROID17-GENERIC-FOUNDATION.md` for bootstrap and build instructions and `docs/development/PHASE-0-BASELINE.md` for the reconciled starting state.

## Documentation

- `SPECIFICATIONS.md` — repository-level product requirements and qualification boundaries.
- `FEATURES.md` — implemented, partial, and planned feature state.
- `FEATURE-ROADMAP.md` — planned feature obligations.
- `BENEFITS.md` — current and planned user/platform value.
- `COMPETITIVE-OBJECTIVES.md` — independent benchmark and differentiation objectives.

## Development boundary

Source acceptance, generic build success, virtual-device boot, physical-device qualification, release, deployment, and Stable acceptance are separate evidence states. Claims in this repository must remain limited to what has been directly verified.
