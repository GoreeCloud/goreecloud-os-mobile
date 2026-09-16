---
title: "Android 17 Generic-Platform Foundation"
version: "0.1.0-dev1"
status: "Development"
last_updated: "2026-09-15"
---

# Android 17 Generic-Platform Foundation

## Purpose

This foundation provides a reproducible starting point for GoreeCloud OS Mobile platform development without claiming support for any physical device.

The pinned upstream baseline is defined in `platform/aosp/android17-baseline.env`. The GoreeCloud product overlay lives under `aosp-overlay/device/goreecloud/generic` and inherits the upstream AOSP ARM64 Cuttlefish phone product.

## Bootstrap

Install Google's `repo` launcher and the normal AOSP host dependencies first. Then run:

```bash
scripts/bootstrap-aosp.sh /path/to/aosp
```

For manifest initialization and pin verification without downloading the full source tree:

```bash
scripts/bootstrap-aosp.sh /path/to/aosp --init-only
```

The bootstrap refuses to overwrite an existing `.repo` workspace. The overlay installer separately refuses to overwrite an existing `device/goreecloud/generic` path. Reconciliation must be explicit rather than destructive.

## Build

After a complete sync and overlay installation:

```bash
scripts/build-generic-arm64.sh /path/to/aosp
```

The Development target is:

```text
goreecloud_cf_arm64_phone-trunk_staging-userdebug
```

The target inherits AOSP's ARM64 Cuttlefish phone product. It is a virtual/generic development target, not a device-support claim.

## Repository validation

Run:

```bash
scripts/validate-platform-foundation.sh --verify-upstream
```

This verifies the repository structure, internal target contract, shell syntax, full manifest commit pin, and the current upstream resolution of the AOSP tag. It does not replace a full AOSP build or boot test.

## Qualification boundary

A successful generic ARM64 build will establish only generic-platform build evidence. A Cuttlefish boot will establish only virtual-device boot evidence. Neither may be used as evidence that the OnePlus Nord N200 (`dre`) can run Android 17 or that GoreeCloud OS Mobile is Release Candidate or Stable.
