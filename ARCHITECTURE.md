# Anjali — Architecture

## Principles

- **Offline-first, no network.** All content ships in the bundle. There is no
  networking layer in the MVP, by design.
- **Deterministic core.** The logic that decides *what to show* is pure and
  unit-tested, separated from SwiftUI.
- **Robust to bad data.** A single malformed prayer must never crash the app.
- **Small surface area.** Three tabs, one card, one player. Complexity is the
  enemy of a sacred pause.

## Layers

```
┌────────────────────────────────────────────────────────┐
│ Views (SwiftUI)                                          │
│   RootView → Onboarding | MainTabView                    │
│   Today / Find / Me / PrayerPlayer / Completion          │
├────────────────────────────────────────────────────────┤
│ Coordination & State                                     │
│   AppCoordinator (tabs, deep links, player presentation) │
│   AppSettings (UserDefaults-backed preferences)          │
│   PrayerLibrary (in-memory prayer store)                 │
├────────────────────────────────────────────────────────┤
│ Engine (pure, testable)                                  │
│   TodayContextEngine  TimeBandResolver  PrayerDataLoader │
│   DeepLink  NotificationManager  PrayerAudioAssetResolver│
├────────────────────────────────────────────────────────┤
│ Models                                                   │
│   Prayer + PrayerText (Codable, from JSON)               │
│   PrayerCompletion, FavoritePrayer (SwiftData)           │
│   Enums: TimeContext, Moment, Deity, Intention, PlayMode │
├────────────────────────────────────────────────────────┤
│ Data                                                     │
│   Resources/prayers.json (bundled seed content)          │
│   SwiftData store (user-generated state)                 │
└────────────────────────────────────────────────────────┘
```

## Key components

### TimeBandResolver
Pure mapping from a wall-clock time to a `TimeContext` (five bands):
- Dawn 04:30–07:59, Morning 08:00–11:59, Midday 12:00–15:59, Sunset 16:00–19:59,
  Night 20:00–04:29 (wraps past midnight).
- Every minute maps to exactly one band — no gap. Midday is its own band with a
  distinct ivory/saffron theme ("A pause at midday").
- Exposes a `minutesSinceMidnight` entry point for trivial, clock-free testing.

### PrayerDataLoader
Loads `prayers.json`, validating fields. Decodes leniently: a bad element
decodes to `nil` and is skipped rather than aborting the whole file. Throws only
when the resource is missing/unreadable — never for individual records. This is
how acceptance criterion *"invalid content does not crash"* is met.

### TodayContextEngine
The heart of Today. Given a `TodayEngineInput` (prayers, time band, explicit
moment, preferred deity, situations stored under the legacy
`favoriteMoments` key, and a per-prayer
`CompletionRecency` map) it returns a `TodayContext` (theme, copy, selected
prayer, alternates). Pure function — no clocks, no globals — so every rule is
deterministically unit-tested.

Completion **never excludes** a prayer; it applies a graded recency penalty
(this session −90, earlier today −60, yesterday −20, within 3 days −10, then 0)
so the day feels fresh while tomorrow's repetition is allowed. A prayer's
`RotationPolicy` tunes this: `.dailyAnchor` prayers (Gayatri, Om Shanti, a
simple Ganesha invocation, the evening close) are exempt from the "yesterday"
nudge so they return each day. Only `needsReview`/unreviewed prayers are
hard-excluded. Scoring is documented in `PRD.md`.

> **Prioritized-situation weighting (implemented in Phase 3B).**
> The stored situation signal is separate from, and lighter than, the
> time-band signal in `TodayContextEngine.score(_:input:)`:
> - time-band inferred moment match: **+60**
> - favourite-moment match: **+20**
> - matched favourite that is *also* compatible with the current band: **+10**
>
> So a favourite never outweighs the time of day on its own, but an aligned
> favourite is gently reinforced.

### PrayerLibrary
`@MainActor ObservableObject` holding all loaded prayers, with lookups by id,
Moment, Intention, and Deity, and the available values that actually have
reviewed content. A Moment is an anytime life situation; the clock ranks Today
but does not lock discovery.

### AppCoordinator
Single owner of navigation: which tab is selected, which prayer (if any) is in
the full-screen player, and the moment a deep link wants to open. URLs and
notification taps both funnel through `handle(_:)`.

### AppSettings
`UserDefaults`-backed preferences (onboarding flag, script preference, ishta
devata, situations to prioritize, enabled reminders, and each reminder's local
hour/minute). Optionals/lists are stored as raw-value strings; reminder times
are keyed by stable reminder slot.

### NotificationManager
Thin wrapper over `UNUserNotificationCenter`. Three reminders with **stable
identifiers** (`reminder.dawn`, `reminder.sunset`, `reminder.sleep`) so
re-scheduling an editable local time replaces rather than duplicates. Each
carries a deep link in `userInfo`. Me commits a new time only after
`UNUserNotificationCenter.add` succeeds and restores the prior value on error.

### PlayerController
`@MainActor ObservableObject` driving one explicit session. Chant is self-led
aloud and Silent is inward reading/repetition; both expose Begin, pause/
continue, and explicit Complete, while their timer is suggested pacing only.
Listen is offered only when `PrayerAudioAssetResolver` finds the selected
prayer's exact approved catalog asset. Normal builds do not enable synthetic or
provisional audio. A Listen load/play failure leaves `hasStarted == false`,
does not start a pretend timer, and cannot persist a completion.

### PrayerAudioAssetResolver
Resolves only `Audio/<prayer-id>.<supported-extension>` when the catalog name
exactly equals the displayed `Prayer.id`. It rejects aliases, recursive/fuzzy
matches, missing assets, and ambiguous duplicate formats. Normal Debug, device,
Release, and TestFlight builds use the approved-catalog policy; an isolated
compile condition is required for repository-only audio research.

## Persistence

- **SwiftData** holds only user-generated state: `PrayerCompletion` and
  `FavoritePrayer`. The container falls back to in-memory if the on-disk store
  can't be created; a persistent banner discloses that degraded state.
- **`prayers.json`** is immutable reference content — never written at runtime.
- **`UserDefaults`** holds lightweight preferences.

## Project format

The Xcode project uses **file-system synchronized groups** (`objectVersion 70`,
Xcode 26+ for the current Apple upload baseline). Files added under `Anjali/`
and `AnjaliTests/` are picked up
automatically; `Info.plist` is excluded from the resources copy via a membership
exception. The test target is a host-based unit test (`TEST_HOST` + `@testable
import Anjali`).

## Testing strategy

Unit tests target the deterministic core:
- `TimeBandResolverTests` — boundary mapping for all five bands (dawn/morning/
  midday/sunset/night), the midnight wrap, and full-day coverage.
- `PrayerDataLoaderTests` — loads seed data, validates fields, skips malformed records.
- `TodayContextEngineTests` — dawn/midday/sunset/night selection, preferred-deity
  ranking, graded recency penalties, daily-anchor "yesterday" waiver, completion
  never excluding, needsReview/unreviewed exclusion, text-only prayers still
  selectable (Silent fallback), explicit-moment override, scoring order, alternates.
- `PrayerAudioAssetResolverTests` and `PlayerControllerTests` — exact-ID policy,
  hidden Listen behavior, no cross-prayer fallback, fail-closed lookup, explicit
  self-led completion, and no pretend Listen completion.

`Scripts/validate_prayers.py` validates `prayers.json` against the Swift enums
(including `rotationPolicy`) and can gate CI.

Current evidence is 75/75 unit/integration tests plus 4/4 current UI tests on
each of large iPhone, compact iPhone, and iPad (12/12 responsive total),
including the Om Namo Narayanaya regression. Manual physical-device and human
accessibility matrices remain pending. Consumer readiness is governed by
the [Daily-Use Consumer Product Plan](docs/DAILY_USE_PRODUCT_PLAN.md);
TestFlight distribution execution remains in
`docs/TESTFLIGHT_READINESS_BACKLOG.md`.
