# Anjali

> A sacred pause, not a session.

Anjali is a digital temple for Hindus worldwide, built entirely around
short-form **micro-prayers** (10–60 seconds). It is an iOS-native daily ritual
object — not a puja guide, not a meditation app, not a bhajan player, not an
astrology app, not a content library.

## North Star

**A sacred pause, not a session.** Open the app, receive a single prayer that
fits the moment, complete it in under a minute, and close the app feeling
steadier. No feeds, no streaks-as-pressure, no recommendations engine pulling
for attention.

## What it does

- **Today** — one contextual prayer card that changes with the time of day
  (Dawn / Morning / Midday / Sunset / Night), each with its own colour theme and
  copy. Selection uses a graded recency model so the card stays fresh while
  daily anchors (Gayatri, Om Shanti, …) can return each day.
- **Prayer Player** — a full-screen, calm experience with
  availability-aware modes:
  - **Chant** is self-led aloud: the app plays no recording.
  - **Silent** is inward reading or repetition: the app plays no sound.
  - **Listen** appears only for a prayer with an exact, approved human
    recording. Normal Debug, device, Release, and TestFlight builds currently
    contain no provisional audio, so Listen is hidden.
  - The complete selected prayer text and meaning remain visible in every mode,
    with explicit Begin/Pause/Continue and completion controls.
  - Completion shows a flame and *"May this action be steady."* with
    **Done / Repeat / Save this prayer**.
- **Find a prayer** — browse by Moment (an anytime situation such as Dawn,
  Leaving home, Study, Travel, Sunset, or Sleep), Intention (such as peace,
  clarity, gratitude, protection, or devotion), or Deity. Today may use the
  clock to rank a prayer, but Moments are never time-locked.
- **Me** — script preference (Devanagari / Transliteration / Both), ishta
  devata, situations to prioritize on Today, editable local reminder times,
  saved prayers, and an offline explanation of the modes.

The implementation and remaining consumer-readiness work are tracked in the
[Daily-Use Consumer Product Plan](docs/DAILY_USE_PRODUCT_PLAN.md).

## Tech

- SwiftUI, Swift, **iOS 17+**
- SwiftData (completions & favourites), `UserDefaults` (preferences)
- AVFoundation (optional local audio), UserNotifications (local reminders)
- XCTest unit tests
- **No third-party dependencies. Offline-first. No network for the MVP.**

## Project layout

```
Anjali/
  Anjali.xcodeproj/            # Xcode project (file-system synchronized groups)
  Anjali/
    AnjaliApp.swift            # App entry, SwiftData container, notifications
    AppCoordinator.swift       # Tab + deep-link + player presentation state
    Models/                    # Prayer, enums, SwiftData models
    Engine/                    # TodayContextEngine, TimeBandResolver, loaders
    Theme/                     # Colour + copy themes per time band
    Views/                     # Today, Player, Moments, Me, Onboarding, shared
    Resources/prayers.json     # 22 structurally valid prayers; human sign-off pending
    Assets.xcassets            # App icon + accent colour
    Info.plist                 # Bundle config + anjali:// URL scheme
  AnjaliTests/                 # Engine, loader, and time-band unit tests
Content/                       # Content pipeline (CSV catalog, review checklist)
AppStore/                      # Listing, privacy policy, app-icon spec, release checklist
Scripts/                       # validate_prayers.py, export_catalog.py, build.sh
README.md  PRD.md  ARCHITECTURE.md  CONTENT_GUIDELINES.md
SETUP.md  STATIC_AUDIT.md  AppStore/RELEASE_CHECKLIST.md
```

## Build & run

Requirements: **Xcode 26+** for current App Store Connect uploads (the project
uses file-system synchronized groups, `objectVersion 70`) and an iOS 17+
simulator or device.

```bash
# Open in Xcode
open Anjali/Anjali.xcodeproj

# Or run content validation, a Release build, and all tests.
# The script discovers an available iPhone simulator automatically.
./Scripts/build.sh
```

In Xcode: select the **Anjali** scheme and an iOS 17 simulator, then ⌘R to run
or ⌘U to test.

## Deep links

- `anjali://moment/{id}` — open the Moments flow for a moment (e.g.
  `anjali://moment/dawn`)
- `anjali://prayer/{id}` — open a specific prayer (e.g.
  `anjali://prayer/shiva-namah`)

Local reminders (`reminder.dawn`, `reminder.sunset`, `reminder.sleep`) carry
these deep links so a tap lands in the right place.

## Content & sourcing

All prayers are well-known, traditional mantras with honest source notes. We do
**not** generate Sanskrit. See [CONTENT_GUIDELINES.md](CONTENT_GUIDELINES.md).
Structural validation currently passes, but named cultural/theological review
is still 0/22 and blocks external distribution.

## Release status

The current implementation passes structural validation for 22/22 prayer
records, 75/75 unit/integration tests, and the current responsive UI matrix:
4/4 each on large iPhone, compact iPhone, and iPad (12/12 total). Those checks
are not a consumer release decision: manual physical-device behavior and human
accessibility review remain pending, and named cultural/theological sign-off
is still 0/22.

The application is therefore blocked from external TestFlight. The
repository-owned, implementation-ready task sequence is
[docs/TESTFLIGHT_READINESS_BACKLOG.md](docs/TESTFLIGHT_READINESS_BACKLOG.md).
Detailed subtask briefs are in
[docs/testflight-tasks/](docs/testflight-tasks/README.md). Jira and Notion, if
used, are copies of these repository plans.

The separate website marketing, icon-candidate, screenshot, and waitlist work
is tracked in
[docs/MARKETING_LANDING_PAGE_TASKS.md](docs/MARKETING_LANDING_PAGE_TASKS.md).
It does not change the release verdict or cultural-review requirements above.
