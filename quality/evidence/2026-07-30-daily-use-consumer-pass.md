# Daily-use consumer pass — 30 July 2026

Status: `verification_pending`

This is implementation and verification evidence, not cultural, legal,
pronunciation, accessibility, or release approval. The canonical product tasks
and remaining gates are in
[`docs/DAILY_USE_PRODUCT_PLAN.md`](../../docs/DAILY_USE_PRODUCT_PLAN.md).

## Reported failure and root cause

The owner opened Om Namo Narayanaya, tapped Begin, saw Chant selected, and
received no sound or useful explanation.

The old path made several conflicting promises:

1. The catalog advertised Listen although no approved recording was bundled.
2. The only same-ID repository MP3 was a 112.752-second Suno-generated song
   excluded from the product bundle.
3. The player silently removed unavailable Listen and chose Chant.
4. Chant intentionally produced no app sound, but the UI did not explain that.
5. Candidate-song durations had leaked into text sessions, so this
   micro-prayer was configured for 113 seconds.

The Devanagari (`ॐ नमो नारायणाय`), IAST
(`Oṃ Namo Nārāyaṇāya`), and meaning were present in the catalog. The failure
was product state, availability, and layout—not absent prayer text.

## Audio/source audit result

Read-only searches covered 492 audio files under Documents and 574 under
Downloads, including Anjali, Digital Temple, and Svara:

- Eleven Anjali m4a files are macOS Lekha synthetic speech.
- Nine Anjali MP3 files and every credible exact Digital Temple alternative
  are Suno-generated music.
- Several Svara files are byte-identical copies or false thematic matches.
- No recording has the complete production evidence set: named human
  performer, consent and distribution rights, heard transcript, exact approved
  text/hash, pronunciation approval, measured timing, and device sign-off.

No audio was copied, moved, renamed, deleted, or enabled. There is currently no
consumer-suitable human recording in the audited projects. Detailed row-level
evidence remains in
[`Content/audio_candidate_manifest.csv`](../../Content/audio_candidate_manifest.csv)
and
[`2026-07-29-audio-lyrics-source-audit.md`](2026-07-29-audio-lyrics-source-audit.md).

## Product and research decisions

- Listen means an exact, approved human recitation. It is hidden until that
  promise can be fulfilled.
- Chant means the person recites aloud at their own pace; no recording plays.
- Silent means the person reads or repeats the prayer inwardly; no sound plays.
- Both self-led modes show the full selected script and meaning and require
  explicit Begin and Complete.
- A Moment is an anytime situation in the day, not an eligibility or clock
  restriction. Intention and Deity are separate discovery dimensions.
- Reminders are optional ordinary local notifications at user-selected times.
- Normal Debug, physical-device, Release, and TestFlight builds exclude all
  provisional TTS/generated audio. An explicit engineering-only compilation
  condition is required even to resolve a repository fixture.

Research used to define this contract:

- [Apple audio guidance](https://developer.apple.com/design/human-interface-guidelines/playing-audio)
  for discoverable, predictable, user-initiated playback.
- [Apple AVAudioSession](https://developer.apple.com/documentation/avfaudio/avaudiosession)
  for future production playback/session behavior.
- [Apple accessibility guidance](https://developer.apple.com/design/human-interface-guidelines/accessibility)
  for text equivalents, Dynamic Type, and non-color state.
- [Apple notification guidance](https://developer.apple.com/design/human-interface-guidelines/managing-notifications)
  for contextual permission and in-app control.
- [Hindu American Foundation overview](https://www.hinduamerican.org/learn/hinduism-faq)
  and [Vedanta Society on japa](https://vedanta.org/2010/articles/in-praise-of-japa/)
  for the broad distinction between spoken, repeated, and inward practice.
  Named Anjali reviewers—not these general sources or an agent—must approve
  prayer-specific classifications.
- [US Copyright Office](https://www.copyright.gov/register/pa-sr.html) for the
  distinction between a composition and a particular sound recording.

## Implemented change

### Prayer session

- Uses exact-ID audio resolution under the approved-catalog policy.
- Hides Listen throughout Today, onboarding, Me, lists, and player when an
  exact approved recording is absent.
- Shows one stable player layout with mode explanation, Prayer Text, Meaning,
  progress/status, and mode-specific controls.
- Prevents completion before Begin.
- Requires explicit completion in Chant and Silent.
- Leaves a failed Listen unstarted and cannot record a pretend completion.
- Makes prayer text selectable and immediately responsive to the live script
  preference.
- Restores Om Namo Narayanaya from the leaked 113-second song duration to a
  20-second suggested self-led duration. Eight other affected records were
  restored to documented micro-prayer targets.

### First use and daily return

- Reduces onboarding to the product promise, optional skip, live script
  preview, and optional deity preference.
- Defers reminders and favorite situations until the person has entered the
  product.
- Adds a truthful reason to the Today recommendation.
- Uses mode-specific Today actions and renames Change to Another prayer.
- Adds an offline “How Anjali works” guide in Me.
- Keeps the product pressure-free: no streak, leaderboard, punishment, feed,
  account, tracking, or analytics.

### Discovery and preferences

- Replaces the mixed browser with Moment, Intention, and Deity.
- Groups Moments into daily rhythm and everyday life and explicitly says they
  can be opened anytime.
- Applies Devanagari, transliteration, or both immediately on Today, player,
  discovery lists, and Saved.
- Renames favorite-moment settings to situations that Today should prioritize
  and explains the effect.

### Reminders and accessibility

- Stores an editable hour/minute for each stable reminder ID.
- Uses locale-aware time pickers and replaces the existing system request.
- Rolls the UI back when rescheduling fails.
- Reconciles local toggles with pending iOS requests on foreground.
- Provides an Open iOS Settings recovery action after denial.
- Gives the player close control a 44-by-44-point target and adds selected
  accessibility traits to onboarding chips.

## Automated evidence

Commands:

```text
python3 Scripts/export_catalog.py
python3 Scripts/validate_prayers.py
xcodebuild test -quiet -project Anjali/Anjali.xcodeproj -scheme Anjali \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro Max,OS=26.5' \
  -derivedDataPath /private/tmp/AnjaliConsumerUnitFinal \
  -only-testing:AnjaliTests
xcodebuild test -quiet -project Anjali/Anjali.xcodeproj -scheme Anjali \
  -destination '<large iPhone, compact iPhone, or iPad destination>' \
  -derivedDataPath '<destination-specific clean path>' \
  -only-testing:AnjaliUITests
```

Results:

- Generated catalog contains all 22 records and no enabled audio assets.
- Structural content validation: 22/22.
- Named human content sign-off: 0/22.
- Unit/integration tests: 75/75 passed.
- Current UI tests: 4/4 on iPhone 17 Pro Max, 4/4 on iPhone 17e, and
  4/4 on iPad (A16)—12/12 responsive tests passed.
- Final current-source automated total: 87/87 passed, 0 failed, 0 skipped.
- UI coverage includes first use through explicit Begin/Complete, largest
  accessibility text, saved-prayer process relaunch, and the exact Om Namo
  Narayanaya report with both scripts, no unsupported Listen mode, and the
  user-visible Find tab.

The nonfatal `DebuggerVersionStore` warning appeared during simulator launch;
every result bundle completed successfully.

Result bundles:

- Unit/integration:
  `/private/tmp/AnjaliConsumerUnitFinal/Logs/Test/Test-Anjali-2026.07.30_15-58-01--0400.xcresult`
- Large iPhone UI:
  `/private/tmp/AnjaliConsumerUIFinalLarge/AnjaliConsumerUIFinalLarge.xcresult`
- Compact iPhone UI:
  `/private/tmp/AnjaliConsumerUIFinalCompact/AnjaliUITests.xcresult`
- iPad UI:
  `/private/tmp/AnjaliConsumerUIFinaliPad/Logs/Test/Test-Anjali-2026.07.30_15-55-01--0400.xcresult`

## Physical-device build/install evidence

Device: iPhone 16 Pro Max, iOS 26.5.2  
UDID: `00008140-000E658A36FB001C`  
Bundle: `app.anjali.Anjali` version 1.0 (1)

Commands:

```text
xcodebuild clean build -quiet -project Anjali/Anjali.xcodeproj \
  -scheme Anjali -configuration Debug \
  -destination 'platform=iOS,id=00008140-000E658A36FB001C' \
  -derivedDataPath /private/tmp/AnjaliConsumerDevice
xcrun devicectl device install app --device 00008140-000E658A36FB001C \
  /private/tmp/AnjaliConsumerDevice/Build/Products/Debug-iphoneos/Anjali.app
xcrun devicectl device process launch \
  --device 00008140-000E658A36FB001C --terminate-existing app.anjali.Anjali
```

Results:

- Clean signed device build succeeded.
- Direct app-bundle inspection found 0 MP3, M4A, AAC, WAV, or CAF files.
- Binary string inspection confirms the final user-visible `Find` and
  `Find a prayer` copy is in this installed build.
- Install succeeded and iOS returned a new application container URL.
- Process launch succeeded.

This proves that the inspected current binary is installed and running on the
connected device. It does not claim that a person completed manual functional,
notification-delivery, or accessibility checks.

## Open gates

- 22/22 prayers still need named human content/context sign-off.
- A small, rights-cleared, human-recorded, pronunciation-reviewed audio pilot
  must be commissioned before Listen can ship.
- Production Listen still needs an explicit playback state machine,
  interruptions, route changes, lock/background behavior, and exact measured
  phrase timing after an approved recording exists.
- Manual VoiceOver, Voice Control, contrast, Reduce Motion, and physical-device
  reminder delivery/denial/timezone checks remain open.
- Moderated first-time consumer and cultural-advisor testing remains open.
- Signing, App Store Connect configuration, public privacy/contact URLs,
  upload, internal TestFlight installation, and Beta App Review remain open.

Therefore this working tree is substantially more honest and usable for owner
testing, but it is not a consumer or external-TestFlight release candidate.
