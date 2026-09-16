---
title: "GoreeCloud OS Mobile — Phase 0 Baseline"
version: "0.1.0-dev1"
status: "Development"
last_updated: "2026-09-15"
---

# GoreeCloud OS Mobile — Phase 0 Baseline

## Verified source-control baseline

Phase 0 began from GitHub `main` commit `d9566d690315abf75d38270f56137d2dfcbcb2ff` on September 15, 2026.

At that exact revision, the repository contained the root documentation controls, one Android wallpaper-partner module, and its GitHub Actions workflow. It did **not** contain an AOSP platform manifest, GoreeCloud Android product definition, device tree, Android build-system integration, generic ARM64 product target, or full-ROM source checkout.

The live repository also contained no current `dre` or `avicii` device source tree. Historical documentation about those targets therefore does not establish current repository implementation state.

## Current development boundary

This branch starts the Android 17 generic-platform foundation. It adds:

- a pinned Android 17 AOSP manifest baseline;
- a GoreeCloud ARM64 Cuttlefish product overlay;
- guarded bootstrap, overlay-installation, build, and validation scripts;
- repository CI for the foundation metadata and upstream pin;
- repository documentation required to describe the current implementation state.

It does **not** establish a successful AOSP sync, compilation, Cuttlefish boot, physical-device boot, `dre` Android 17 migration, production signing, OTA, bootloader relock, Release Candidate qualification, or Stable qualification. Those states require separate evidence.

## Upstream baseline

The initial Android 17 baseline is `android-security-17.0.0_r1`, whose AOSP platform-manifest commit is pinned as `c231f742884cf3b32d668cac6209c51fb012ce66`. Android 17 corresponds to API level 37.

The generic validation product is intentionally based on AOSP Cuttlefish ARM64 rather than a physical device. This keeps the strategic Android 17 platform track separate from the current OnePlus Nord N200 (`dre`) Android 16 physical qualification track.
