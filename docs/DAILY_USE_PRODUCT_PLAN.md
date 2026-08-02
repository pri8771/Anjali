# Daily-Use Consumer Product Plan

Last updated: 30 July 2026  
Owner: product + engineering + named cultural/audio reviewers  
Status: `in_progress`; current code is improved but consumer verification remains

This is the repository source of truth for turning Anjali from a functional
prototype into a product people can understand, trust, and return to. Jira and
Notion may copy these IDs and descriptions but may not replace this plan.
TestFlight candidate freeze (`TF-005`) is blocked until every P0 item below is
verified and the named-human gates are complete.

## Product promise

Anjali is a private, respectful daily prayer companion:

> Open, receive or choose one fitting prayer, practice for a brief moment, and
> return to the day.

Daily use should come from usefulness at a stable moment—waking, leaving home,
starting work, seeking calm, sunset, or bedtime—not from feeds, shame,
leaderboards, or a breakable streak.

## Research-backed product model

- Hindu practice can include spoken prayer, japa, mental repetition,
  time-associated ślokas, devotional song, meditation, and individualized
  routines. The interface must describe its specific practice instead of
  implying that one mode represents every tradition.
  [Hindu American Foundation](https://www.hinduamerican.org/learn/hinduism-faq)
  and the
  [Vedanta Society](https://vedanta.org/2010/articles/in-praise-of-japa/)
  provide useful overviews; named Anjali reviewers still decide product
  classifications.
- Apple expects audio controls to be discoverable, user-initiated, and
  predictable across routes and interruptions. Audio also needs an equivalent
  text experience.
  [Playing audio](https://developer.apple.com/design/human-interface-guidelines/playing-audio),
  [AVAudioSession](https://developer.apple.com/documentation/avfaudio/avaudiosession),
  and
  [Accessibility](https://developer.apple.com/design/human-interface-guidelines/accessibility)
  define the platform baseline.
- Apple recommends contextual notification permission and in-app notification
  controls. Prayer reminders are ordinary, user-chosen reminders and must not
  claim Time Sensitive urgency.
  [Managing notifications](https://developer.apple.com/design/human-interface-guidelines/managing-notifications).
- Marketplace listings consistently promise clear human audio, readable
  prayer text, meanings, offline use, reminders, and either guided practice or
  a japa counter. These are competitor claims, not evidence of their cultural
  correctness:
  [Prarthana](https://apps.apple.com/us/app/prarthana-daily-hindu-prayers/id1597899453),
  [Mantra Japa](https://apps.apple.com/us/app/mantra-japa-sadhana/id6760542141),
  and [Sri Mandir](https://apps.apple.com/in/app/sri-mandir-puja-chadhava/id1637621461).
- Existing Anjali, Digital Temple, Svara, and Downloads assets contain no
  documented human recording with performer consent, distribution rights,
  heard transcript, pronunciation approval, and device sign-off. Synthetic
  Lekha speech and Suno-generated music are not consumer audio.

## Mode contract

| Mode | Promise | Required behavior |
|---|---|---|
| Listen | Hear this exact prayer | Show only when an exact, human, rights-cleared, reviewed recording is bundled. Display the full prayer text. Playback failure must stop and offer recovery; it must not run a pretend silent timer. |
| Chant | Recite aloud yourself | State before Begin that no recording plays. Show the complete selected script, an elapsed/suggested-time indicator, Pause/Continue, and explicit Complete. Never invent a repetition count. |
| Silent | Read or repeat inwardly | State that no sound plays. Show the complete selected script, explicit Begin/Pause/Continue, and explicit Complete. This supports public, work, travel, bedside, and inward practice without claiming a single theological definition. |

## What Moments means

A Moment answers “What is happening in my day?” It is an anytime discovery
context, never a time lock. Today may use the clock to rank a prayer, but a
person may open Dawn at night.

- **Moment:** dawn/beginning the day, leaving home, starting work, meeting,
  study, travel, sunset, sleep.
- **Intention:** clarity, gratitude, protection, peace, focus, courage,
  prosperity, wisdom, devotion.
- **Deity:** an optional devotional filter.

The current data still contains `anxiety`, `gratitude`, and `protection` in the
legacy `Moment` enum for compatibility. The consumer browser uses the
`Intention` dimension; a later reviewed data migration can remove duplicate
legacy classifications.

## Task index

| ID | Priority | Task | Status | Blocks |
|---|---|---|---|---|
| DU-001 | P0 | Truthful, understandable prayer session | signed device build/install verified; manual QA pending | consumer build |
| DU-002 | P0 | Human audio pilot and approval pipeline | `blocked` on reviewer/performer/rights | Listen, external beta |
| DU-003 | P0 | Named prayer-content review and complete text system | `blocked` on named reviewer | external beta |
| DU-004 | P1 | Useful one-tap Today loop | `in_progress` | daily-use beta |
| DU-005 | P1 | Coherent Moment/Intention/Deity discovery | `code_complete`; usability verification pending | daily-use beta |
| DU-006 | P1 | Short, teach-through-use onboarding | `code_complete`; usability verification pending | first-use beta |
| DU-007 | P1 | Editable, trustworthy local reminders | `code_complete`; device verification pending | daily-use beta |
| DU-008 | P1 | Production iOS playback behavior | `blocked` on DU-002 pilot asset | Listen |
| DU-009 | P1 | Accessibility and responsive-layout completion | automated responsive matrix complete; human accessibility pending | external beta |
| DU-010 | P1 | Moderated consumer and cultural beta | `blocked` on DU-001–DU-009 | candidate decision |

## DU-001 — Truthful, understandable prayer session

**Summary and expected change:** Every action and mode must do what its label
promises. A user opening Om Namo Narayanaya must immediately see `ॐ नमो
नारायणाय` and `Oṃ Namo Nārāyaṇāya`, understand that Chant is self-led, receive
visible start/pause feedback, and never be offered absent or robotic audio.
This is required because the old path advertised Listen, silently switched to
Chant, then ran for 113 seconds using duration leaked from an excluded Suno
song.

**Implementation:**

1. Use the exact-ID resolver under the approved-catalog policy in every normal
   Debug, device, Release, and TestFlight build. `DEBUG` alone never enables
   provisional audio.
2. Derive Today chips, the primary CTA, onboarding choices, Me preferences, and
   player modes from actual current-bundle availability. Hide Listen when the
   exact approved asset is absent.
3. Restore intended 10–60 second content durations independently of candidate
   song lengths. Candidate audio never mutates text-mode pacing.
4. Keep one stable player layout. Label Prayer Text and Meaning, show a
   persistent mode explanation, use mode-specific controls, display state/time,
   and require explicit completion for Chant and Silent.
5. On Listen load/play failure, remain uncompleted, show an actionable failure,
   and offer another mode. Never record a Listen completion unless playback
   actually began.
6. Keep prayer text selectable and responsive to the app-wide script setting.

**Acceptance and evidence:** unit tests cover resolver policy and controller
start/pause/failure/explicit completion; the current responsive UI matrix,
including Om Namo Narayanaya, passes on large/compact iPhone and iPad; a clean
device build contains zero audio; human QA verifies text, controls, mode
switching, completion mode, large text, and VoiceOver.

## DU-002 — Human audio pilot and approval pipeline

**Summary and expected change:** Replace zero consumer recordings with a small,
excellent pilot of 8–12 human recitations. We are doing this because a robotic
or generated sacred voice damages trust more than honest text-only behavior.
The result is prayer-specific Listen availability with matching readable text,
not superficial 22/22 coverage.

**Implementation:**

1. DU-003 freezes the approved Devanagari, IAST, chosen variant, intended
   repetitions, context, and target duration before recording.
2. Product appoints a qualified human reciter and named
   pronunciation/cultural reviewer. Vedic and lineage-sensitive material needs
   appropriately qualified review.
3. Obtain written performer consent and worldwide rights for TestFlight,
   App Store distribution, offline bundling, marketing previews if applicable,
   and future edits. Record performer, owner, allowed uses, date, and evidence
   location without committing private documents.
4. Record one clean human voice per prayer. Preserve the lossless master; v1
   uses no generated voice, music bed, stacked voices, or artificial reverb.
5. Create a verbatim heard transcript with every invocation, omission,
   addition, and repetition. Compare it line-by-line with canonical content.
6. Master a derived `<prayerID>.m4a` to `Content/audio_spec.md`; calculate
   SHA-256 and bind transcript, review, rights, timing, and device evidence to
   that exact hash.
7. Measure phrase/line timing by listening. Never estimate from characters or
   divide the duration evenly.
8. Enable `audioAssetName`, bundle membership, and Listen for one prayer only
   after every gate passes. Any byte change invalidates the approval.

**Pilot order:** choose 8–12 records only after DU-003 review. Prefer broad
daily coverage such as a morning anchor, universal peace, beginning-work,
study, travel/courage, gratitude, evening, and sleep. Do not finalize the list
or claim appropriateness without the named reviewer.

**Acceptance and evidence:** every enabled hash has performer/rights evidence,
heard transcript, pronunciation/context approval, technical report, measured
timing, automated validation, and named physical-iPhone sign-off.

## DU-003 — Named prayer-content review and complete text system

**Summary and expected change:** Make the displayed sacred content trustworthy
and useful to a learner without pretending a model approved it. All 22 records
currently lack named sign-off; this blocks external beta and audio recording.

**Implementation:**

1. Execute `TF-001` and `Content/tf-001-review-packet.md` record by record.
2. Review Devanagari, declared transliteration standard, plain meaning, exact
   source/variant, deity, Moment, Intention, time context, rotation, and target
   duration.
3. Add an optional human-reviewed easy-pronunciation field only if the reviewer
   can maintain it consistently; never derive it silently from IAST.
4. Preserve original script and IAST in every player. Apply script changes to
   Today, player, Moment/Intention/Deity lists, and Saved without relaunch.
5. Split prayer lines structurally in a future schema before synchronized audio;
   line breaks must come from reviewed content, not UI width.

**Acceptance:** 22/22 named sign-off validator passes; no unresolved
`needsReview`; script switching tests pass across every surface; approved
content commit is immutable input to DU-002.

## DU-004 — Useful one-tap Today loop

**Summary and expected change:** Today should answer “What can I do right now?”
with one credible suggestion and one clear action. This supports daily return
without a feed or coercive streak.

**Implementation subtasks:**

1. Show one short reason derived from actual ranking, such as “For the
   beginning of your day” or “From your chosen deity”; never invent a benefit.
2. Use an explicit CTA—Listen now, Begin chanting, or Read silently—based on
   the exact mode the player will open.
3. Rename Change to Another prayer and explain that it cycles up to three
   contextually ranked alternatives.
4. Add a small private recent-practice section in Me: last seven completion
   dates and modes, with no streak, score, failure state, or public sharing.
5. Let Saved prayers remain one tap away in Me and consider pinning up to three
   on the discovery screen; do not add a fourth tab.

**Acceptance:** the CTA and player mode always match; ranking reason is
deterministic/tested; recent history survives relaunch; missing a day produces
no negative copy or lost progress.

## DU-005 — Coherent discovery

**Summary and expected change:** Replace the mixed flat Moments list with three
understandable ways to find a prayer: Moment, Intention, or Deity. This makes
Dawn self-explanatory and prevents users from thinking it is clock-restricted.

**Implementation:** group Moments into Daily rhythm and Everyday life; browse
inner aims through actual `Intention` values; include descriptions on every
row and detail screen; keep legacy moment deep links working; use the current
script preference in list rows.

**Acceptance:** Dawn can be opened at any time and explicitly says so; all
reviewed prayers remain reachable; intention and deity filters return only
matching records; VoiceOver reads label plus description once.

## DU-006 — Short, teach-through-use onboarding

**Summary and expected change:** Get a new person to a useful prayer quickly
instead of asking them to configure concepts they have not experienced.

**Implementation subtasks:**

1. Keep the welcome and a live script preview.
2. Keep deity optional with a plain explanation.
3. Remove or defer favorite Moments and reminders until after the first
   completed prayer, unless the same screen shows exact effects/times.
4. Do not offer Listen as a preference until approved Listen content exists.
5. Explain Chant and Silent inline and default to Chant in text-only builds.
6. Add Skip and selected VoiceOver traits to every custom chip.

**Acceptance:** first prayer is reachable in two deliberate actions; every
choice has a visible consequence; largest Dynamic Type and VoiceOver pass.

## DU-007 — Editable, trustworthy local reminders

**Summary and expected change:** Let the person choose the time for Dawn,
Evening, or Sleep reminders. Fixed unexplained 06:30/18:30 reminders are not a
consumer-ready daily cue.

**Implementation:** store hour/minute per stable reminder ID in UserDefaults;
show locale-aware `DatePicker` controls; schedule the chosen local time; replace
the same notification ID only after the new request succeeds; roll the UI back
on error; request permission only after opt-in; reconcile saved toggles with OS
authorization and pending requests on foreground; provide Open Settings after
denial.

**Acceptance:** custom times survive relaunch, reschedule without duplicates,
and remain unchanged after a failed update. Named real-device QA verifies
grant, denial, Settings revocation, delivery, tap route, timezone/daylight
change, and all three slots.

## DU-008 — Production iOS playback behavior

**Summary and expected change:** Once DU-002 supplies an approved pilot file,
Listen must behave like a real iOS media experience rather than a timer around
`AVAudioPlayer`.

**Implementation subtasks:**

1. Replace overlapping booleans with explicit idle, preparing, playing, paused,
   interrupted, failed, and completed state.
2. Inject the player and clock for deterministic tests. Use the player
   completion delegate, not a `0.99` polling assumption.
3. Activate `.playback` only when playback starts and deactivate with
   `notifyOthersOnDeactivation` when the session ends.
4. Handle phone/Siri interruptions and pause when the active output route is
   removed. Surface current route and actionable recovery when helpful.
5. Product decides whether a sub-minute prayer continues while locked. If yes,
   add the background capability, Now Playing metadata, and remote commands;
   if no, document and test foreground-only behavior.
6. Verify silent switch, volume zero, speaker, wired/Bluetooth headphones,
   AirPlay, background/foreground, lock, interruption, and airplane mode.

**Acceptance:** state-transition unit tests and named physical-device evidence
cover success and every failure/recovery path; exact audio clock drives measured
text highlighting.

## DU-009 — Accessibility and layout

Run automated audits plus named human checks for VoiceOver, Voice Control,
Switch Control, Full Keyboard Access on iPad, all Dynamic Type sizes, increased
contrast, Reduce Motion, light/dark behavior, and all five palettes. Controls
must be at least 44×44 points; mode controls must wrap or scroll; selected state
must not rely on color; completion focus must move predictably. Exercise compact
iPhone, large iPhone, iPad full screen, and a supported multitasking width.

## DU-010 — Moderated consumer and cultural beta

Recruit first-time users, regular practitioners from more than one background,
the named content reviewer, and accessibility users. Give tasks rather than
instructions: find a prayer for study, open Dawn at night, change script,
practice Om Namo Narayanaya aloud and silently, edit a reminder, save a prayer,
and return the next day. Record comprehension, failures, and trust concerns.
No P0/P1 usability or cultural defect may remain open at candidate freeze.

## Current verified implementation slice

- Normal Debug and Release resolve only approved catalog audio; the Debug TTS
  copy phase is removed.
- Listen is hidden when exact approved audio is absent.
- Chant and Silent explain sound behavior, expose explicit controls, show full
  prayer text/meaning, and require explicit completion.
- Nine leaked candidate-song durations were restored to documented
  micro-prayer targets, including Om Namo Narayanaya from 113 seconds to 20.
- Today mode chips and CTA use current availability.
- Discovery now separates Moment, Intention, and Deity and explains that
  Moments are available anytime.
- Browse and Saved rows honor script preference.
- Reminder times are editable and persisted.
- Structural content validation passes 22/22; 75/75 unit/integration tests and
  12/12 current responsive UI tests pass.

Remaining status is `verification_pending`: named prayer review is 0/22, no
acceptable human audio exists, complete UI/accessibility/device matrices have
not yet passed, and consumer research tasks DU-004/DU-006/DU-008–DU-010 remain.
