# Build 4 Upload Evidence

## Why this build exists

Build 3 (uploaded 11 August 2026, evidence in
`2026-08-11-build-3-upload.md`) was archived from commit `b3c5684`. Two
commits landed on `dev` on 14 August 2026 after that upload —
`e64dade` (self-led player rework: Begin -> Complete instead of
pause/countdown, neutralized variant labels) and `59c9bd2` (all pilot audio
replaced with chant-standard Suno regenerations) — and were never included in
an uploaded build. `origin/main` was also 4 commits behind `origin/dev` at
the time. Build 4 exists to put the actual current app in front of App Store
Connect and the pilot tester.

## Result

- **Date:** 14 August 2026
- **App:** Anjali (`app.anjali.Anjali`)
- **Version/build:** 1.0 (4)
- **Source checkout:** `59c9bd2` (HEAD of both `main` and `dev` after
  fast-forwarding `main` to `dev` and pushing). Working tree was clean except
  for the intentional `CURRENT_PROJECT_VERSION` bump from 3 to 4 in
  `Anjali/Anjali.xcodeproj/project.pbxproj` (Debug and Release configs of the
  `Anjali` app target only; test targets untouched).
- **Archive:** `xcodebuild archive -destination "generic/platform=iOS"
  -allowProvisioningUpdates CODE_SIGN_STYLE=Automatic
  DEVELOPMENT_TEAM=796XH483R4` completed with `** ARCHIVE SUCCEEDED **`.
  Signed with `Apple Development: Priyansh Chordia (JB639M996T)` under team
  `796XH483R4`, provisioning profile `iOS Team Provisioning Profile: *`.
  Archive stored at `BuildReports/build-4/Anjali.xcarchive` (log:
  `BuildReports/build-4/archive.log`).
- **Upload:** `xcodebuild -exportArchive` with `AppStore/ExportOptions.upload.plist`
  (`method: app-store-connect`, `destination: upload`, `signingStyle:
  automatic`, `teamID: 796XH483R4`) completed with `Upload succeeded` and
  `** EXPORT SUCCEEDED **` (log: `BuildReports/build-4/export.log`). Because
  `destination` is `upload`, no local `.ipa` is written; delivery is directly
  to App Store Connect.
- **App Store Connect processing:** Not verified from this session. No App
  Store Connect API key is configured on this machine (checked keychain,
  environment, and common credential paths — none found), and an interactive
  browser session for `appstoreconnect.apple.com` requires an Apple ID
  sign-in this session cannot and should not perform (entering the account
  password is outside this agent's allowed actions). A human must open App
  Store Connect to confirm build 4 reaches "Ready to Submit" and to check
  processing time / any Apple-side warnings.

## Confirmation the archive contains the 14 August fixes

- Bundle `CFBundleShortVersionString` = `1.0`, `CFBundleVersion` = `4`
  (verified via `plutil -p` on the archived `Info.plist`).
- The archived app bundle's pilot audio files match the exact byte sizes
  introduced by commit `59c9bd2` (chant regenerations), e.g.
  `ganesha-gam__v01-traditional.mp3` = 919,080 bytes,
  `hanuman-manojavam.mp3` = 812,760 bytes,
  `vishnu-shantakaram__v01-traditional.mp3` = 944,692 bytes — all matching
  the post-regeneration sizes, not the pre-regeneration (build 3) sizes.
- `Anjali/Anjali/Views/Player/PrayerPlayerView.swift` and
  `PlayerController.swift` in this checkout include the Begin -> Complete
  rework from `e64dade`.

## Candidate contents (unchanged from build 3 except audio + player flow)

Listen-mode variant picker (Default / Version 1 / Version 2), all pilot audio
now regenerated to the chant standard in
`Content/SUNO_CHANT_REGENERATION.md` **except** `vishnu-shantakaram`, which
Suno's moderation rejected as false-positive "copyrighted material" for all
three regeneration jobs (public-domain verse); its two legacy song-style
files (`v01-traditional`, `v02-energy-edm`) remain unchanged from build 3.
See `docs/RISKS.md` RISK-009 (added by this session) for tracking.

## Submission status

Not submitted for Beta App Review or App Store review. This build does not
change any of the metadata gaps recorded for build 3 (screenshots, support
URL, copyright, review contact, description/keywords) — those still need
completion in App Store Connect directly, and this session could not verify
or fill them because no App Store Connect API credentials are available and
this session will not perform an interactive Apple ID login. The repository
also retains the named-prayer-review gate (RISK-001, 0/22) and the
human-recording gate for pilot audio; this build does not close either.

## Checks run

- `python3 Scripts/validate_prayers.py` — structural validation passed
  (22/22); human sign-off remains 0/22 (`--require-signoff` was not invoked
  to bypass or alter this gate, per standing instruction not to touch
  RISK-001).
- Fast-forward merge `main` -> `dev` HEAD (`59c9bd2`), pushed to
  `origin/main` (`f5b1a9b..59c9bd2`) — no conflicts, no rewritten history.
- `xcodebuild archive` — succeeded.
- `xcodebuild -exportArchive` (upload) — succeeded, `Upload succeeded`.
- Archived pilot-audio file sizes cross-checked against commit `59c9bd2`
  diff stats — match.

## Not checked / requires the human owner

- App Store Connect build-processing status and "Ready to Submit" state for
  build 4.
- Whether build 4 needs to be manually attached to the 1.0 App Store version
  and/or the `Anjali Pilot` TestFlight group (build 3 was; build 4's group
  assignment was not verified from this session).
- All build-3 metadata gaps (screenshots, support URL, copyright, review
  contact, description/keywords).
