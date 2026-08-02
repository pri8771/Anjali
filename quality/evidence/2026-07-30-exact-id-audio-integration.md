# Exact-ID audio integration evidence — 2026-07-30

Status: `verification_pending`

> Historical intermediate-build evidence. It is superseded by
> [`2026-07-30-daily-use-consumer-pass.md`](2026-07-30-daily-use-consumer-pass.md).
> Normal Debug/device builds no longer copy the 11 TTS fixtures, the current
> signed device app contains zero audio, and the current result is 75/75
> unit/integration plus 12/12 responsive UI tests. The details below are
> retained to show the earlier exact-ID integration step.

## Change under test

- `PrayerAudioAssetResolver` resolves only
  `Audio/<displayed prayer ID>.<extension>`.
- Debug may use a null-catalog same-ID preview fixture.
- Release requires a same-ID `.m4a` catalog asset; the current null catalog
  therefore remains text-only.
- Missing, duplicate, nested, top-level, aliased, sibling, or same-deity assets
  fail closed.
- The `vishnu-shantakaram → vishnu-narayana` and
  `hanuman-manojavam → hanuman-namah` substitutions were removed.
- Debug copies only the 11 known-input TTS `.m4a` fixtures. The nine
  untranscribed Suno MP3 candidates remain unchanged in the repository and are
  absent from the built app.

Source hashes at verification:

```text
fb47b53079f3bfa578ec5b423af11574792c8603871f8714b81eb1a856d22709  Anjali/Anjali/Engine/PrayerAudioAssetResolver.swift
023748f4b325a48a880b71a53a1d4bc1a2dd7377a4a7da8e9406df5ef033ad38  Anjali/Anjali/Views/Player/PlayerController.swift
1935cd5090e2cc8aeae44b8bd13a2a516b1c33e0dfec20ef285a842a6b1eb129  Anjali/Anjali.xcodeproj/project.pbxproj
```

These are working-tree file hashes, not a frozen candidate commit.

## Automated results

Command:

```bash
xcodebuild test \
  -project Anjali/Anjali.xcodeproj \
  -scheme Anjali \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro Max,OS=26.5' \
  -only-testing:AnjaliTests/PrayerAudioAssetResolverTests
```

Result: **9/9 passed, 0 failures**. The suite covers exact same-ID Debug
preview, Release null rejection, Release `.m4a` policy, alias rejection,
missing asset, duplicate extensions, no recursive/top-level lookup, and both
explicit cross-prayer regressions.

The full `AnjaliTests` unit/integration target was then run on the same
iPhone 17 Pro Max / iOS 26.5 simulator. XCTest result summary:
**67/67 passed, 0 failed, 0 skipped**.

The four-test `AnjaliUITests` smoke suite was attempted twice. The simulator
first rejected the test runner as `Busy ("Application failed preflight
checks")`; after restarting the simulator, Xcode repeatedly reported
`DebuggerLLDB.DebuggerVersionStore.StoreError` / `no debugger version` and the
stalled invocation was interrupted. No UI-test pass is claimed for this
working-tree revision. The earlier 29 July matrix remains historical evidence,
not a substitute for a rerun.

Command:

```bash
xcodebuild build \
  -project Anjali/Anjali.xcodeproj \
  -scheme Anjali \
  -configuration Release \
  -destination 'generic/platform=iOS' \
  CODE_SIGNING_ALLOWED=NO
```

Result: **BUILD SUCCEEDED**. Inspection of
`DerivedData/.../Build/Products/Release-iphoneos/Anjali.app` found **0** `.mp3`,
`.m4a`, `.wav`, `.caf`, or `.aac` files.

The signed physical-device Debug build also succeeded. Its `Audio` directory
contains exactly **11 `.m4a` fixtures and 0 MP3 files**.

Additional checks:

```text
Anjali/Anjali.xcodeproj/project.pbxproj: OK
git diff --check: passed
Scripts/validate_prayers.py: 22 structurally valid; 0/22 human sign-offs
```

## Physical device

Device: iPhone 16 Pro Max, iOS 26.5.2  
UDID: `00008140-000E658A36FB001C`  
Bundle: `app.anjali.Anjali`

At 00:11 EDT:

- `xcrun devicectl device install app` succeeded.
- `xcrun devicectl device process launch` succeeded.

Installation and launch do not prove audible words or pronunciation. The user
or named reviewer must still perform the per-prayer listening matrix in
`docs/AUDIO_LYRIC_ALIGNMENT_PLAN.md`. Timing/highlighting was not added because
no measured approved sidecars exist.
