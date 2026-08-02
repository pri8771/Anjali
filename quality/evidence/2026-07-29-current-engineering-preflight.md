# Current-working-tree engineering preflight — 2026-07-29

## Scope and validity

This is an engineering preflight of the **current working tree**, not a frozen
or release candidate. At start, `git rev-parse HEAD` was
`93e9826f43a08dd31dbb42fbcd8c2620e635e309`. `git status --short` was not
empty: it included modified product/project/workflow files and untracked
factory, documentation, quality, and source/test files. Consequently no result
below establishes an exact-commit candidate gate or a TestFlight-ready build.

Environment: macOS 26.5.2 (25F84); Xcode 26.6 (17F113); iOS 26.5 simulator
runtime. The original sandbox could not contact CoreSimulatorService; destination
discovery and simulator tests were rerun with authorized CoreSimulator access.

## Content and factory checks

| Command | Result |
|---|---|
| `python3 Scripts/validate_prayers.py` | PASS — 22 prayer records structurally valid. |
| `python3 Scripts/validate_prayers.py --require-signoff` | EXPECTED FAIL (exit 1) — 0/22 named human sign-offs; all 22 records lack `provenance.reviewer` / `reviewedOn`. This is an intentional visible release blocker. |
| `python3 -m json.tool .factory/project-context.json` | PASS. |
| `python3 -m json.tool quality/quality-manifest.json` | PASS. |
| Pinned factory registration verifier | NOT RUN — this repository does not vendor the verifier and no authorized `ios_app_factory_rules` 0.2.0 checkout/verifier path was available during this preflight. No path was invented. |

## Discovered destinations and simulator matrix

`xcodebuild -showdestinations -project Anjali/Anjali.xcodeproj -scheme Anjali`
and `xcrun simctl list devices available` found these selected shutdown iOS 26.5
simulators:

| Matrix role | Device / UDID | Result |
|---|---|---|
| Large iPhone | iPhone 17 Pro Max — `3C3D0E59-B4CF-4687-94E9-062ACC483C7B` | PASS: `DESTINATION="platform=iOS Simulator,id=3C3D0E59-B4CF-4687-94E9-062ACC483C7B" ./Scripts/build.sh`. Release build passed; 58 unit/integration tests and 4 UI tests passed. `BuildReports/build.log` and `BuildReports/test.log` preserved. The test log records `** TEST SUCCEEDED **`. |
| Compact iPhone | iPhone 17e — `2C8D689D-759E-4F73-B2B6-671E93E36C08` | PASS in follow-up: Debug UI-only run passed 4/4. Result bundle: `Test-Anjali-2026.07.29_17-58-45--0400.xcresult`. |
| iPad | iPad (A16) — `33694F79-26D4-45A0-B1FA-2524E255C3A4` | PASS in follow-up: Debug UI-only run passed 4/4. Result bundle: `Test-Anjali-2026.07.29_18-01-55--0400.xcresult`. |

No parallel simulator test was deliberately started by this preflight. Existing
booted simulators owned by other work were not shut down or repurposed.

The first follow-up attempted the old task-brief command with
`-configuration Release`. It initially failed to compile because the unit-test
bundle uses `@testable import` while a normal Release module disables
testability. Adding `ENABLE_TESTABILITY=YES` proved compilation but all four UI
tests then failed because the reset/seed launch hooks are intentionally
`#if DEBUG` and therefore absent from Release. This was an automation-design
defect, not a product result. The maintained release gate now does one separate
Release build/archive and runs UI automation in Debug, which keeps test hooks
out of the shipped Release binary. The two successful commands were:

```bash
xcodebuild test -quiet \
  -project Anjali/Anjali.xcodeproj -scheme Anjali \
  -destination "platform=iOS Simulator,id=<COMPACT_OR_IPAD_UDID>" \
  -only-testing:AnjaliUITests
```

`xcresulttool get test-results summary` independently reported four passed,
zero failed for each result bundle.

## Unsigned generic archive and inspection

The agent's initial archive attempt was interrupted before a result. A
follow-up run then completed the same engineering check:

```bash
xcodebuild archive -quiet \
  -project Anjali/Anjali.xcodeproj -scheme Anjali \
  -configuration Release -destination "generic/platform=iOS" \
  -archivePath BuildReports/Anjali-current.xcarchive \
  CODE_SIGNING_ALLOWED=NO
```

Result: PASS, exit 0. Inspection of
`BuildReports/Anjali-current.xcarchive/Products/Applications/Anjali.app`
established:

- bundle `app.anjali.Anjali`, version `1.0`, build `1`, minimum iOS `17.0`,
  iPhone+iPad device family, `anjali` URL scheme, and
  `ITSAppUsesNonExemptEncryption = false`;
- arm64 Mach-O application binary with only Apple system
  frameworks/libraries in `otool -L`;
- bundled `PrivacyInfo.xcprivacy`, `prayers.json`, and iPhone/iPad app icons;
- privacy manifest declares no tracking or collected data and lists
  UserDefaults reason `CA92.1`;
- bundled and source prayer catalogs have the same SHA-256:
  `f29928e0bf5cbf7622daa711dad52bd42c02d9b69331057ef47b5f529af8ced7`;
- no `.mp3`, `.m4a`, `.wav`, or `.caf` file exists in the application bundle;
- compiled 120×120 iPhone and 152×152 iPad icons have no alpha.

`codesign` correctly reported that the app is not signed. This unsigned command
is engineering-only and does not prove signing, provisioning, Organizer
validation, App Store Connect processing, or TestFlight.

## Warnings, limitations, and decision

- The successful large-iPhone build/test logs contain the benign Xcode warning:
  `Metadata extraction skipped. No AppIntents.framework dependency found.`
- UI automation also logged debugger-version-store messages during launch; all
  four large-iPhone UI tests nevertheless passed.
- Simulator testing cannot establish real-device accessibility usability,
  notification delivery/interruption, provisioning, App Store metadata,
  signing, processing, or TestFlight installation.

**Decision: verification_pending / no automated release GO.** The dirty-tree
caveat, intentional 0/22 human-signoff failure, and unrun factory verifier each
independently prevent a candidate or distribution claim. The large/compact/iPad
simulator matrix and follow-up unsigned archive inspection passed, but neither
is a signed, exact-commit distribution gate.
