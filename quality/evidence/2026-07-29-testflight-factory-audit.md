# TestFlight and App Factory Audit Evidence

Date: 29 July 2026

## Verdict

The repository is registered and structurally conformant with
`pri8771/iOS_app_factory_rules` 0.2.0. Engineering checks are green, but the
project remains `verification_pending` and is not ready for external TestFlight
until the human, public-URL, signing, App Store Connect, and real-device gates
below close.

## Environment

- macOS 26.5.2 (25F84)
- Xcode 26.6 (17F113)
- iOS/iPadOS 26.5 simulator runtime (23F77)
- Factory standard: `main`, version 0.2.0; audited local checkout `89ce224`

## Automated results

| Check | Destination | Result |
|---|---|---|
| Structural prayer validation | Python 3 | pass, 22/22 |
| Release simulator build | iPhone 17 Pro, iOS 26.5 | pass |
| Unit/integration suite | iPhone 17 Pro, iOS 26.5 | pass, 58/58 |
| UI suite | iPhone 17 Pro, iOS 26.5 | pass, 4/4 |
| UI responsive suite | iPhone 17e, iOS 26.5 | pass, 4/4 |
| UI responsive suite | iPad (A16), iPadOS 26.5 | pass, 4/4 |
| Catalog export repeatability | SHA-256 before/after regeneration | pass, identical |
| Info/privacy plist lint | `plutil` | pass |
| Generic iOS device archive | arm64, Release, unsigned | pass |
| Factory registration verifier | local canonical standard | pass |
| Release sign-off validator | 22 prayer records | expected block, 0/22 signed |

The UI suite covers onboarding through completion, text/audio-unavailable
fallback, the primary path at the largest accessibility text size, and saving a
prayer across process termination and relaunch.

## Archive inspection

`BuildReports/Anjali.xcarchive` was built with Xcode 26.6 and the iOS 26.5 SDK,
with code signing disabled.

- arm64 Mach-O application
- bundle id `app.anjali.Anjali`
- version `1.0`, build `1`
- minimum iOS 17.0
- iPhone and iPad device families
- app icon resources present
- `PrivacyInfo.xcprivacy` present with no tracking/no collected data and
  UserDefaults reason `CA92.1`
- `ITSAppUsesNonExemptEncryption = NO`
- `prayers.json` present
- zero `.mp3`, `.m4a`, `.wav`, `.caf`, or `.aac` files
- system frameworks only; no third-party dynamic dependencies

This does not establish signing, provisioning, Organizer/App Store validation,
upload processing, or TestFlight installation.

## Factory remediations

- Added factory registration, lock, agent instructions, quality manifest,
  feature contracts, lifecycle documentation, and completion evidence.
- Made persistence degradation visible and persistence failures recoverable.
- Made reminder scheduling awaited/throwing and aligned UI state with confirmed
  notification-center changes.
- Kept UI-test reset behavior out of Release.
- Added an offline in-app privacy notice and dynamic version display.
- Added Reduce Motion handling to the primary button style.
- Added persistence/relaunch and largest-text automated coverage.
- Made simulator discovery and Release compilation part of the build harness;
  moved CI to macOS 26.
- Made catalog generation byte-stable.
- Excluded all provisional TTS/generated audio from target membership and set
  every shipping audio reference to null. The source files remain only for
  review/reference.

## Intentional blocking evidence

`python3 Scripts/validate_prayers.py --require-signoff` exits non-zero and lists
all 22 prayers because no named human reviewer/date is present. This is the
correct release behavior and must not be bypassed.

## Checks not established here

- named cultural/theological approval for each prayer
- manual VoiceOver order, visual contrast, and Reduce Motion usability
- notification grant/denial/delivery and tap routing on a real device
- real-device audio interruption, offline, background/foreground, and
  persistent-store checks
- verified-live privacy and support URLs
- App Store Connect ownership, name, age rating, category, metadata,
  screenshots, signing/provisioning, and unique uploaded build number
- signed archive validation, upload processing, external Beta App Review, and
  TestFlight installation

One earlier shared-simulator run was invalidated when another application stole
the foreground. The identical suite passed on isolated destinations; only the
isolated green results above are treated as product evidence.
