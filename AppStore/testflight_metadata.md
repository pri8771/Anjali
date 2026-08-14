# Anjali TestFlight Metadata

Canonical repository copy. App Store Connect is a synchronized copy, not the
source of truth.

**Status:** blocked draft — named cultural/theological sign-off is 0/22 and the
manual physical-device and accessibility matrices remain pending.
Placeholders must also be replaced before external Beta App Review.
**Approved build:** `[BUILD_NUMBER]`
**Approved source commit:** `[FULL_GIT_SHA]`
**Copy approved by/date:** `[NAME — YYYY-MM-DD]`

## Beta App Description

```text
Anjali is an offline, accountless Hindu micro-prayer app for iPhone and iPad.
It offers one short prayer suited to the selected moment and time of day, with
Devanagari, transliteration, and a plain-English meaning. Testers can browse by
Moment, Intention, or Deity, use self-led Chant or Silent modes, save prayers
locally, and schedule optional local reminders at times they choose.

This candidate is text-led. Chant means reciting aloud yourself and plays no
recording; Silent means reading or repeating inwardly and plays no sound. The
complete prayer text and meaning remain visible in both modes. Normal builds
contain no provisional generated/TTS audio, so Listen is hidden unless an exact,
reviewed human recording is approved and bundled for that prayer.
Anjali has no sign-in, advertising, analytics, purchases, or network service.
```

## Feedback Email

```text
support@priyanshchordia.com
```

This field is required for external TestFlight. Verify the mailbox receives and
replies before entering it.

## What to Test

```text
Build [BUILD_NUMBER]

1. Fresh install: complete the two-screen onboarding flow.
2. From Today, begin the offered prayer. Confirm Chant explains that it is
   self-led aloud with no recording, Silent explains that no sound plays, and
   the complete prayer text and meaning remain visible.
3. Confirm Listen is not offered anywhere in this build because it contains no
   approved human recordings or provisional generated/TTS audio.
4. Browse by Moment, Intention, and Deity. Open Dawn at any time and confirm the
   app explains that Moments are situations, not clock restrictions.
5. Complete a prayer and use Done, Repeat, and Save. Force quit and relaunch;
   confirm onboarding, settings, and saved prayers
   persist.
6. If comfortable, enable a local reminder, change its time, verify the edited
   time survives relaunch, verify delivery and tap routing, then disable it.
   Also try denying notification permission.
7. Open anjali://moment/dawn and anjali://moment/beforeWork.
8. Repeat the main path in airplane mode, dark mode, largest text, and
   VoiceOver.

Please report the device model, iOS/iPadOS version, build number, steps,
expected result, actual result, and a screenshot or screen recording when safe.
For sacred-text or cultural concerns, identify the prayer title and exact field.
```

## TestFlight App Review Contact

Store private contact values in App Store Connect if repository publication is
inappropriate.

- First name: `Priyansh`
- Last name: `Chordia`
- Phone: `[REVIEW_CONTACT_PHONE]`
- Email: `priyansh.chordia@gmail.com`

## Sign-in Information

- Sign-in required: **No**
- Demo account: **Not applicable**

## Review Notes

```text
Anjali is an offline-first, accountless app. No login or demo account is
required. The app has no network layer, advertising, analytics, tracking, or
in-app purchases, and it does not collect or transmit user data.

All prayer text is bundled in the app. This candidate intentionally contains no
provisional generated/TTS audio, so Listen is hidden. Chant is a self-led aloud
mode with no app recording; Silent is inward reading or repetition with no app
sound. Both display the complete prayer text and meaning and require explicit
completion.

Optional reminders use local notifications only. Notification permission is
requested only after the user explicitly enables a reminder in the Me tab.
Enabled reminder times are editable. The app remains usable if permission is
denied, and Me offers a route to iOS Settings.

Suggested path: launch → complete onboarding → Today → Read silently → Begin
silent prayer → Complete → Done. Find a prayer and Me are available from the
tab bar. The app works in airplane mode.

Deep-link examples:
- anjali://moment/dawn
- anjali://moment/beforeWork
```

## Current repository evidence — not external-beta approval

- Structural prayer validation: 22/22 records pass.
- Unit/integration tests: 75/75 pass.
- Current responsive UI matrix: 4/4 passes on each of large iPhone, compact
  iPhone, and iPad (12/12 total), including Om Namo Narayanaya, first use,
  largest text, and saved-prayer relaunch persistence.
- Named cultural/theological sign-off: 0/22.
- Manual device, notification-delivery, and human accessibility evidence:
  pending.

Do not submit this external-beta packet until those human and verification
blockers are closed. The canonical product sequence is
[`../docs/DAILY_USE_PRODUCT_PLAN.md`](../docs/DAILY_USE_PRODUCT_PLAN.md).

## Public and internal values

- Privacy policy URL: `https://priyanshchordia.com/apps/anjali/privacy/`
- Support URL: `https://priyanshchordia.com/apps/anjali/support/`
- App Store Connect app Apple ID: `[APP_APPLE_ID]`
- Bundle ID: `app.anjali.Anjali`
- Marketing version: `1.0`
- Distribution team: `796XH483R4` — ownership must be confirmed
- External group name: `[EXTERNAL_GROUP_NAME]`
- Internal group name: `Anjali Pilot`

## Final synchronization checklist

- [ ] Every bracketed placeholder is replaced.
- [ ] Build and Git SHA match the uploaded binary.
- [ ] Feedback mailbox test succeeded.
- [ ] Beta description and review notes match shipping behavior.
- [ ] App Store Connect Test Information matches this file.
- [ ] Build/group What to Test matches this file.
- [ ] Product, privacy, content, QA, and release owners approved the packet.
