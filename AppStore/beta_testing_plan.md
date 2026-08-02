# Anjali Beta Testing Plan

This plan describes testing after a build reaches TestFlight. The canonical
task definitions, dependencies, acceptance criteria, and evidence requirements
are in `../docs/TESTFLIGHT_READINESS_BACKLOG.md`. Consumer-product behavior and
its P0/P1 gates are canonical in
[`../docs/DAILY_USE_PRODUCT_PLAN.md`](../docs/DAILY_USE_PRODUCT_PLAN.md).

## Current pre-beta state

- Structural content validation passes 22/22 records.
- 75/75 unit/integration tests and the current responsive UI matrix pass:
  4/4 each on large iPhone, compact iPhone, and iPad (12/12 total), including
  the Om Namo Narayanaya regression.
- Named cultural/theological sign-off remains 0/22.
- Manual physical-device, notification-delivery, accessibility, and
  moderated-consumer matrices remain pending.

External TestFlight is blocked. The automated checks above are implementation
evidence, not approval to invite consumers.

## Principles

- Repository evidence is authoritative; TestFlight, Jira, and Notion mirror it.
- No result is pre-checked. Record Pass, Fail, or Not Applicable with a reason.
- Normal builds contain no provisional generated/TTS audio and hide Listen when
  no exact approved human recording is bundled.
- Chant is self-led aloud and plays no recording. Silent is inward reading or
  repetition and plays no sound. The complete prayer text and meaning remain
  visible in both.
- No analytics will be added just to measure beta participation or retention.
- TestFlight feedback, a monitored email, interviews, and Apple crash
  diagnostics are the feedback channels. There is no in-app rating form.
- Sacred-text accuracy, privacy mismatch, crashes/data loss, and inaccessible
  primary paths are stop-ship conditions.

## Stage 1 — Internal TestFlight

**Entry:** TF-009 upload/processing is complete.
**Participants:** smallest useful internal group of engineering, QA, product,
and cultural advisors. Apple permits up to 100 App Store Connect users, but
Anjali does not need to approach that limit.
**Duration:** evidence-driven; no fixed week promise.

### Goals

- Prove the processed TestFlight binary installs on real iPhone and iPad.
- Exercise the complete functional, offline, notification, persistence,
  accessibility, and layout matrix in
  `../docs/templates/TESTFLIGHT_QA_EVIDENCE.md`.
- Verify Moment, Intention, and Deity discovery; a Moment is an anytime
  situation and is never clock-locked.
- Verify user-edited local reminder times persist, replace the stable request
  without duplicates, deliver, and deep-link correctly.
- Collect cultural-advisor feedback while TF-001 review is finalized.
- Confirm the shipped build contains no provisional audio and makes no
  unsupported network/privacy claim.

### Exit

TF-010 has named go/no-go approval, no open P0 or blocking P1, and all required
manual rows have evidence.

## Stage 2 — Controlled external beta

**Entry:** TF-001, TF-003, TF-004, TF-010, and TF-011 are complete; all P0 and
release-blocking P1 items in `DAILY_USE_PRODUCT_PLAN.md` are verified; named
content review is 22/22.
**Participants:** 20–30 invited practitioners representing varied devices,
accessibility needs, and Hindu traditions.
**Distribution:** email invitation to a closed external group. Do not start
with a public link.

### Goals

- Validate that the one-prayer flow is understandable and respectful.
- Find prayer-source, transliteration, meaning, context, or tone concerns.
- Validate reminders, deep links, airplane-mode operation, persistence, dark
  mode, large text, and VoiceOver in real-world use.
- Identify crashes and confusing or unreachable states.

### Tester questions

1. Did any prayer text, transliteration, meaning, source, deity association, or
   presentation feel inaccurate or disrespectful? Identify the prayer/field.
2. Could you understand and finish the Today → prayer → completion flow?
3. Before beginning, was it clear that Chant means reciting aloud yourself with
   no app recording and Silent means inward reading with no sound?
4. Could you always see the complete selected prayer text and meaning?
5. Did Moment, Intention, and Deity feel distinct? Could you open Dawn outside
   dawn without thinking it was restricted?
6. Did saved prayers and settings remain after relaunch?
7. Could you change a reminder time, and did it behave as expected after grant,
   denial, delivery, and relaunch?
8. Did the app work in airplane mode?
9. Was anything clipped, low contrast, difficult with VoiceOver/large text, or
   confusing on iPad?
10. Did you experience a crash, lost data, or a stuck screen? Include device,
   OS, build, reproduction steps, and safe screenshots/video.

### Stop conditions

Pause invitations and return to TF-005 for any:

- credible sacred-text/content error or cultural harm;
- privacy behavior that differs from “Data Not Collected”/offline claims;
- reproducible crash, data loss, unusable primary path, or major accessibility
  barrier;
- repeated notification state that claims success when scheduling failed;
- accidental provisional audio, a visible Listen affordance without an approved
  recording, or unexpected network/SDK inclusion.

### Exit

TF-012 records invited and installed counts available from TestFlight,
feedback-response count, crash/defect totals by severity, disposition of every
content concern, and named product/QA/content/release go/no-go.

## Stage 3 — Optional expanded external beta

Only expand after the controlled cohort exits green. Choose a second invited
cohort or a limited public link with explicit device/OS criteria and tester
limit. Apple allows external groups up to 10,000 testers, but that limit is not
a target. This offline app has no server-load hypothesis to validate.

Expansion must have a named objective such as broader iOS 17 device coverage or
accessibility representation. If no new objective exists, proceed to App Store
submission work instead of collecting vanity participation.

## Operational cadence

- Review TestFlight crash/feedback queues each business day during active beta.
- Acknowledge direct feedback within two business days.
- Put canonical defects and decisions in repository docs/issues first.
- Metadata-only corrections update `testflight_metadata.md` and the App Store
  Connect copy. Binary corrections require a new unique build and TF-005 onward.
- Record each build's 90-day expiration date and stop unsafe/expired builds.

## Success criteria

There is no fabricated percentage, star-rating, launch-time, memory, or
retention target. A beta succeeds when:

- all release acceptance criteria in TF-010/TF-012 are evidenced;
- no open P0 or release-blocking P1 remains;
- every content concern has named human disposition;
- no unexplained TestFlight crash cluster remains;
- the final privacy/content/feature description matches the binary;
- product, QA, content, and release owners record go.
