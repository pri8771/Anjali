# Build 3 Upload Evidence

## Result

- **Date:** 11 August 2026
- **App:** Anjali (`app.anjali.Anjali`)
- **Version/build:** 1.0 (3)
- **Source checkout:** `b3c5684` plus the working-tree audio-variant and build-number changes; the checkout was intentionally not clean because this candidate includes the approved scope change.
- **Archive:** `xcodebuild archive` completed successfully for `generic/platform=iOS`.
- **Upload:** `xcodebuild -exportArchive` completed with `** EXPORT SUCCEEDED **` and reported `Upload succeeded`.
- **App Store Connect processing:** Complete.
- **TestFlight status:** Build 3 is `Ready to Submit`, assigned to the internal `Anjali Pilot` group, with the existing one-person invite.
- **App Store version:** Build 3 is attached to version 1.0 in the App Store submission record.

## Candidate contents

This build includes the Listen-mode variant picker with Traditional as the
default, plus the verified EDM/Indian hip-hop alternatives documented in
`Content/pilot_audio_variants_manifest.csv`. The generated audio remains
explicitly disclosed and TestFlight-only.

## Submission status

The app has not been submitted for App Review. App Store Connect still has
`Add for Review` disabled because the listing lacks required metadata,
including screenshots, support URL, copyright, review contact details, and
completed description/keywords. The repository also retains the named prayer
review and human-recording gates; this evidence does not waive them.

## Checks run

- `python3 Scripts/validate_prayers.py` — structural validation passed; human sign-off remains 0/22.
- Pilot audio manifest hash check — 8/8 packaged hashes match.
- `git diff --check` — passed.
