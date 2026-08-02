# Anjali — Product Requirements

## Product thesis

Most spiritual apps are built like media platforms: long sessions, libraries to
binge, streaks that turn devotion into a chore. Anjali rejects that. It is a
**ritual object**, not a content destination.

> A sacred pause, not a session.

The core loop is intentionally tiny: **open → receive one fitting prayer →
complete it in 10–60 seconds → close, steadier.** Success is measured by how
quickly and calmly a person can return to their life, not by time-in-app.

Anjali is for Hindus worldwide who want a small, dignified, daily touchpoint
with prayer — on the way out the door, before a meeting, in a moment of anxiety,
at sunset, before sleep.

The implementation and verification sequence for making that loop clear,
trustworthy, and useful every day is the
[Daily-Use Consumer Product Plan](docs/DAILY_USE_PRODUCT_PLAN.md).

## What Anjali is NOT

- ❌ A puja/ritual how-to guide
- ❌ A meditation app
- ❌ A bhajan / music streaming app
- ❌ An astrology or horoscope app
- ❌ A bottomless content library or social feed
- ❌ A recommendations engine optimising for engagement

## MVP scope

1. **Onboarding** (first launch only)
   - Screen 1: wordmark **Anjali** + tagline *"A sacred pause for everyday life"*.
   - Screen 2: a few gentle preferences (script, ishta devata).
2. **Three tabs:** Today, Find, Me. Exactly three. No more. Find contains
   Moment, Intention, and Deity browsing.
3. **Today**
   - A single contextual prayer card.
   - Background and copy change by time band: Dawn, Morning, Midday, Sunset, Night.
   - Card: eyebrow label, headline, prayer title, duration chip, modes that
     actually work in the current build, meaning, and a mode-specific **Begin**
     CTA.
   - Selection is deterministic via `TodayContextEngine`.
4. **Prayer Player**
   - Full-screen. The complete selected prayer text and meaning remain visible.
   - **Chant** is self-led aloud practice; the app states that no recording
     plays, provides Begin/Pause/Continue controls, and requires explicit
     completion.
   - **Silent** is inward reading or repetition; the app states that no sound
     plays, provides Begin/Pause/Continue controls, and requires explicit
     completion.
   - **Listen** appears only when an exact, reviewed human recording is bundled
     for that prayer. Normal builds currently contain no provisional audio, so
     Listen is hidden.
   - Suggested progress is shown as a subtle flame/ring or bar without forcing
     a self-led session to end.
   - Completion: flame, *"May this action be steady."*, **Done / Repeat / Save**.
   - **No recommendations** after completion.
5. **Find a prayer** — browse by Moment, Intention, or Deity. A Moment is an
   anytime situation in the user's day, not a clock restriction; Today alone
   uses time of day as a ranking signal.
6. **Me** — script picker, ishta devata, situations to prioritize on Today,
   editable local reminders, saved prayers, and “How Anjali works.”
7. **Notifications** — local only, stable identifiers, deep links into the app.
8. **Offline** — all content comes from bundled JSON. Provisional generated/TTS
   audio is absent from normal builds.

## Acceptance criteria

1. App launches.
2. Onboarding appears on first launch only.
3. Exactly three tabs: Today / Find / Me.
4. Today shows a single contextual prayer card.
5. Background changes by time band.
6. **Begin** opens the prayer player.
7. Chant is clearly self-led aloud with no app sound; Silent is clearly inward
   reading with no app sound; both keep the complete prayer text and meaning
   visible and require explicit completion.
8. Listen is absent unless the exact approved human recording for the displayed
   prayer is bundled; a playback failure cannot run a pretend silent timer or
   record a false Listen completion.
9. Completion records in SwiftData and offers Done / Repeat / Save.
10. Discovery is browseable by Moment, Intention, and Deity, and explains that
    Moments are available anytime.
11. Me exposes preferences.
12. Local reminders can be scheduled at user-editable local times and survive
    relaunch without duplicate requests.
13. Works fully offline.
14. `TodayContextEngine` is unit-tested.
15. Invalid content never crashes the app.
16. `needsReview` prayers are excluded from selection.
17. External TestFlight remains blocked until all 22 prayers have named human
    cultural/theological sign-off and the full UI, device, and accessibility
    matrices pass.

## Microcopy rules

- **Begin** (never "Play")
- **Begin chanting** for self-led aloud practice
- **Read silently** / **Begin silent prayer** for inward practice
- **Listen now** only when approved audio is actually available
- **Done** (never "Next")
- **Repeat**, **Save this prayer**, **Silent prayer**
- *"May this action be steady"* (completion)
- *"A sacred pause for everyday life"* (onboarding tagline)

## Today selection model

`TodayContextEngine` is pure and deterministic. Scoring per prayer:

| Signal | Score |
| --- | --- |
| Matches an explicitly chosen moment | +100 |
| Matches a time-band inferred moment | +60 |
| Matches a favourited moment | +20 |
| Matched favourite also compatible with the band | +10 |
| Time contexts include the current band | +35 |
| Deity matches the user's ishta devata | +40 |
| Supports the user's preferred mode | +15 |
| Needs review | −100 |

**Recency penalties** (a completion *deprioritises*, never excludes — same-day
repetition is discouraged, next-day repetition is allowed):

| Last completed | Score |
| --- | --- |
| This session (unless the user tapped Repeat) | −90 |
| Earlier today | −60 |
| Yesterday | −20 *(waived for `.dailyAnchor` prayers)* |
| Within the last 3 days | −10 |
| 4+ days ago, or never | 0 |

Each prayer carries a **`RotationPolicy`**: `.dailyAnchor` (returns daily —
Gayatri, Om Shanti, a simple Ganesha invocation, the evening close),
`.rotateOften` (default), `.occasional`, `.festivalSpecific` (reserved).

Only `needsReview`/unreviewed prayers are **hard-excluded** from candidacy.
Every other prayer is always completable in a text-led mode, so missing audio
never excludes the prayer. Runtime mode availability, however, must come from
the current approved bundle rather than the catalog's potential modes. Ties
break by featured → sortOrder → id, for stable, reproducible output.

## V2 ideas (explicitly out of MVP)

- Broader Listen coverage after the initial reviewed human-recording pilot.
- A gentle, pressure-free "thread" of completed pauses (not a streak).
- Additional scripts (Tamil, Telugu, Bengali, Gujarati, etc.).
- Regional/festival-aware Today themes (with the same one-card discipline).
- Family/shared altar (one device, multiple quiet profiles).
- Apple Watch complication for a single tap-to-pause.
- Optional iCloud sync of favourites and preferences.

Every V2 idea must pass the north-star test: does it deepen *the pause*, or does
it pull toward *the session*? If the latter, it does not ship.
