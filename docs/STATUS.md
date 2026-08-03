# Project Status

Last verified: 2 August 2026.

## Lifecycle status

`verification_pending`

Anjali is code-complete enough to build and exercise, but it is **not ready for
external TestFlight distribution or App Store review**. The repository is now
registered with `pri8771/iOS_app_factory_rules` 0.2.0 and passes its registration
verifier.

An internal TestFlight pilot delivery is in progress. This is not a declaration
of consumer-release readiness: the app retains the human-review, accessibility,
and product gates below.

## Current objective

Execute the P0/P1 product work in `docs/DAILY_USE_PRODUCT_PLAN.md`, then
`docs/TESTFLIGHT_READINESS_BACKLOG.md` from TF-001 through TF-012 without
weakening the offline/private product contract. These repository plans are
canonical; Jira and Notion are copies only.

## Verified (current working tree; not a frozen candidate)

- Xcode 26.6 with the iOS 26.5 SDK compiles the Release simulator product.
- The current large-iPhone simulator run passes 75/75 unit/integration tests,
  including exact-ID audio, mode availability, controller state, reminder-time,
  content, selection, persistence, and settings regressions.
- The current responsive UI suite passes 4/4 on each of iPhone 17 Pro Max,
  iPhone 17e, and iPad (A16), 12/12 total: first use requires Begin before
  explicit completion, largest text reaches Today, saved prayer data survives
  relaunch, and Om Namo Narayanaya shows both scripts, omits unsupported
  Listen, explains self-led Chant, and exposes visible start/pause state.
- An unsigned generic-device archive passes inspection: expected bundle
  identity/version/build, iOS 17.0, iPhone/iPad family, arm64/system-only
  dependencies, icon, privacy manifest, matching prayer catalog, and zero
  bundled audio. It is explicitly not signing or distribution evidence.
- A clean signed Debug build for the connected iPhone 16 Pro Max succeeds,
  contains zero audio files, installs as `app.anjali.Anjali`, and launches.
  This proves the current binary reached the device; it does not replace the
  pending manual behavior, reminder, and accessibility matrix.
- On 2 August 2026, App Store Connect app record `Anjali` (bundle ID
  `app.anjali.Anjali`) and internal group `Anjali Pilot` were created. The
  automatically signed App Store Connect archive for version 1.0 build 1 was
  accepted by Apple at 15:55 EDT and entered processing. Upload evidence is
  recorded in the Xcode distribution log; the build has not yet been confirmed
  as processed or installed through TestFlight.
- On 2 August 2026, the manually delivered audio-enabled version 1.0 build 2
  archive was accepted by Apple at 21:50 EDT with no upload errors. It is now
  awaiting App Store Connect processing before it can replace build 1 for the
  `Anjali Pilot` tester.
- Structural validation passes for all 22 bundled prayer records.
- A real 1024×1024 RGB app icon with no alpha is bundled.
- `PrivacyInfo.xcprivacy` is bundled and declares no tracking/data collection
  plus UserDefaults reason `CA92.1`.
- No third-party dependencies, networking code, analytics, ads, accounts, IAP,
  or production fixtures were found.
- Save, delete, and reminder mutations no longer imply success before the
  underlying operation succeeds.
- Durable-store fallback is disclosed; UI-test reset hooks compile only in
  Debug.
- TF-001 preparation is complete: the 22-record human review packet and
  model-research cues are available, without any claimed human disposition.
- TF-002 and TF-003/TF-004 repository preflights reconcile local identity and
  metadata claims; neither establishes Apple-account or public-contact facts.
- TF-006 release-gate automation is implemented and locally syntax/structure
  checked. It has not run remotely on a frozen candidate SHA.
- Every normal Debug/device and Release build uses approved-catalog audio
  policy. The synthetic Debug copy phase is removed; stale build residue cannot
  authorize playback. No discovered local asset meets the human
  performer/rights/transcript/pronunciation/device gates.
- Today and the player no longer advertise absent audio. Chant and Silent
  explain sound behavior, show complete text/meaning and explicit state, and
  require explicit completion.
- Nine durations that had drifted to provisional song lengths were restored to
  documented 10–60 second targets; Om Namo Narayanaya is 20 seconds, not 113.
- Discovery separates Moment, Intention, and Deity, explains that Moments are
  available anytime, and honors script preference in browse/saved rows.
- Reminder times are editable, locale-rendered, persisted, and rescheduled by
  stable identifier with rollback on failure.

See `docs/TEST_PLAN.md` and `quality/evidence/` for executed checks and exact
results.

## Verification pending

- A clean exact-commit automated gate, remote CI evidence, signed device
  archive validation, and
  TestFlight processing.
- Manual DU-001 device and responsive-layout usability checks.
- Manual VoiceOver, contrast, Reduce Motion, notification delivery/denial,
  background/foreground, airplane-mode, and real-device checks.
- App Store Connect identity, signing/provisioning, unique next build number,
  beta metadata, processed-build confirmation, internal install, and external
  Beta App Review.

## Release blockers

- **0/22 prayers have named human cultural/theological sign-off.**
  `python3 Scripts/validate_prayers.py --require-signoff` correctly fails.
- The 20 provisional audio source files are excluded from the shipping target
  and catalog. Their source/lyric evidence is now inventoried, but none has
  named listening, pronunciation, rights, timing, and device approval. Re-enable
  only reviewed human recitations through
  `docs/AUDIO_LYRIC_ALIGNMENT_PLAN.md`.
- Public privacy-policy URL and monitored beta contact are not yet supplied and
  verified. The support URL remains required for later App Store submission.
- Human accessibility and real-device TestFlight sign-off is not recorded.
- The Apple account's agreements, role scope, TestFlight tester assignment,
  regions, and beta metadata still need confirmation. The app record and
  uploaded build do not establish them.
- TestFlight build 1 contains the no-audio catalog. A local build-2 candidate
  now bundles 22 exact-ID pilot tracks and labels Listen as experimental
  generated audio; it requires device playback verification and a new upload.

## Next action

Verify DU-001/DU-005/DU-007 on the iPhone and execute the remaining consumer
tasks. In parallel, appoint the TF-001 reviewer and DU-002 human
reciter/pronunciation reviewer, complete TF-002 account ownership, and provide
TF-003 public contact values. Do not freeze TF-005 until the P0 product and
named-human gates pass.

Repository preparation is already available:

- `Content/tf-001-review-packet.md` for the 22-record human review;
- `quality/evidence/2026-07-29-tf-002-apple-identity-preflight.md` for the
  Account Holder handoff; and
- `quality/evidence/2026-07-29-tf-003-tf-004-metadata-preflight.md` for the
  public-contact and TestFlight-copy handoff.
- `quality/evidence/2026-07-29-current-engineering-preflight.md` and
  `quality/evidence/2026-07-29-tf-006-release-automation.md` for the current
  engineering baseline and future exact-SHA gate.
