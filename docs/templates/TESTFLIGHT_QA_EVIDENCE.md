# TestFlight QA Evidence

Copy this file to
`quality/evidence/YYYY-MM-DD-tf-007-manual-qa.md` for local/archive QA or
`quality/evidence/YYYY-MM-DD-tf-010-internal-testflight.md` for the processed
TestFlight build. Do not edit this template into a false completed record.

## Identity

- Task: `[TF-007 or TF-010]`
- Date:
- QA owner:
- Source commit:
- Version/build:
- Distribution: `[local signed / TestFlight internal]`
- Xcode/SDK when relevant:
- App Store Connect delivery/build ID when relevant:

## Device matrix

| Device | OS | Appearance | Text size | Install state | Result | Evidence/defect |
|---|---|---|---|---|---|---|
| Compact iPhone | | light + dark | default + largest | fresh | Not run | |
| Large iPhone | | light + dark | default + largest | fresh/relaunch | Not run | |
| iPad full screen | | light + dark | default + largest | fresh | Not run | |
| iPad narrow multitasking | | light + dark | default + largest | existing | Not run | |

Use only `Pass`, `Fail`, or `N/A — <reason>`. Never pre-check a result.

## Functional and persistence checks

| Check | Result | Notes/evidence |
|---|---|---|
| Fresh launch; onboarding scrolls and completes | Not run | |
| Skip onboarding works | Not run | |
| Today → Read silently → Begin silent prayer → Complete → Done | Not run | |
| Listen is absent when no exact approved human recording ships | Not run | |
| Chant explains self-led/no recording; Begin, pause, and explicit Complete work | Not run | |
| Repeat and Save from completion | Not run | |
| Browse by Moment, Intention, and Deity; Moment is available anytime | Not run | |
| Saved prayer visible after force quit/relaunch | Not run | |
| Delete persists after relaunch | Not run | |
| Settings/onboarding state persists | Not run | |
| Airplane-mode cold launch and full loop | Not run | |
| Deep link from cold state | Not run | |
| Deep link from warm state | Not run | |
| Background/foreground returns to valid state | Not run | |

## Notification checks — real device

| Check | Result | Notes/evidence |
|---|---|---|
| Explicit enable triggers permission at the correct time | Not run | |
| Grant schedules the selected reminder | Not run | |
| Denial leaves app usable and state truthful | Not run | |
| Repeated enable/disable remains consistent | Not run | |
| Settings revocation is reflected/recoverable | Not run | |
| Notification delivers at expected time | Not run | |
| Tap routes into the expected app experience | Not run | |

## Accessibility and layout

| Check | Result | Notes/evidence |
|---|---|---|
| VoiceOver labels and traits | Not run | |
| VoiceOver focus/read order | Not run | |
| No VoiceOver trap on primary path | Not run | |
| Largest text keeps primary actions reachable | Not run | |
| Reduce Motion keeps state changes understandable | Not run | |
| Dawn contrast in light/dark | Not run | |
| Morning contrast in light/dark | Not run | |
| Midday contrast in light/dark | Not run | |
| Sunset contrast in light/dark | Not run | |
| Night contrast in light/dark | Not run | |
| Meaning does not depend on color alone | Not run | |
| iPad full-screen composition acceptable | Not run | |
| iPad narrow-width composition acceptable | Not run | |

## Defects

| ID | Severity | Device/OS | Reproduction | Expected | Actual | Status/retest |
|---|---|---|---|---|---|---|
| | | | | | | |

Severity: P0 privacy/content harm, crash/data loss, unusable primary path; P1
major accessibility/reminder/persistence/navigation fault; P2 material but
avoidable; P3 polish/future.

## Sign-off

- Crash/feedback queue reviewed:
- Open P0:
- Open release-blocking P1:
- QA decision: `[GO / NO-GO]`
- QA owner/date:
- Engineering owner/date:
- Product/content owner/date:
- Release owner/date:

No `GO` is valid while a required row says `Not run` or an open P0/blocking P1
exists.
