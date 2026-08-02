# Anjali — App Store Listing (template)

Fill-in-the-blanks for App Store Connect. Character limits noted; stay within
them. Copy is written to be culturally respectful and honest about the
offline-first, no-account design.

**Current status:** not approved for external TestFlight or App Store
submission. Named cultural/theological sign-off is 0/22, and complete UI,
device, accessibility, and consumer verification remain pending. See the
[Daily-Use Consumer Product Plan](../docs/DAILY_USE_PRODUCT_PLAN.md).

---

## App name (30 chars max)

```
Anjali
```

## Subtitle (30 chars max)

```
A sacred pause, anytime.
```
*(24 characters)*

## Promotional text (170 chars max, editable any time)

```
One short prayer for the moment you're in — Sanskrit with meaning, offline and private. A sacred pause, not a session.
```

## Description (4000 chars max)

```
Anjali is a small, quiet temple in your pocket — built entirely around
short prayers you can complete in 10 to 60 seconds. A sacred pause, not a
session.

Open Anjali and you're offered a single prayer suited to the moment and the
time of day. No feed to scroll. No streak pressure. No endless library to
sort through. Just one prayer, chosen for now — and when you're done, you
close the app and return to your life, a little steadier.

MOMENTS AND INTENTIONS
Anjali meets you where you are. Moments describe what is happening in your
day — dawn, leaving home, starting work, a meeting, study, travel, sunset, or
sleep — and are available anytime, never locked to the clock. Intentions help
you browse by an inner aim such as peace, clarity, gratitude, protection, or
devotion. You can also browse by deity.

FIVE TIMES OF DAY
The app changes with the light. Dawn, morning, midday, sunset, and night
each carry their own colour and tone, so opening Anjali feels different at
6am than it does at 9pm.

TWO TEXT-LED WAYS TO PRAY
- Chant: recite aloud yourself at your own pace. The app plays no recording.
- Silent: read or repeat the prayer inwardly. The app plays no sound.
The complete prayer text and meaning stay visible, and you decide when the
prayer is complete.

SANSKRIT, HONESTLY PRESENTED
Each prayer shows the Sanskrit in Devanagari, a transliteration, and a plain
English meaning, with an honest note on its source. Choose to read Devanagari,
transliteration, or both. We use only well-known, traditional mantras — we do
not fabricate sacred text.

BROWSE BY MOMENT, INTENTION, OR DEITY
Find a prayer for a situation in your day, an inner aim, or a deity — Ganesha,
Shiva, Vishnu, Krishna, Hanuman, Devi, Lakshmi, Saraswati, and Surya — plus
universal peace mantras.

YOURS, AND PRIVATE
- Works fully offline. No network required, ever.
- No account, no sign-in.
- Choose an ishta devata, favourite a few moments, and set gentle local
  reminders for times you choose — notifications are only requested if you turn
  them on.
- Save the prayers that stay with you.

Anjali is a daily ritual object, not a content app. It will never try to keep
you scrolling.

No data collected. No account required. Just you, the moment, and the prayer.
```

## Keywords (100 chars max, comma-separated, no spaces)

```
prayer,mantra,Hindu,Sanskrit,Vedic,Gayatri,Om,bhakti,devotion,puja,japa,calm,ritual,Ganesha,Shiva
```
*(verify ≤100 chars in App Store Connect; trim from the right if needed)*

## URLs

- **Support URL:** **TBD — required before App Store submission; publish early
  enough to test before external beta**
- **Privacy Policy URL:** **TBD — publish and verify before external TestFlight**
- **Marketing URL (optional):** TBD

## Category

- **Primary:** Lifestyle
- **Secondary (optional):** Health & Fitness *(for the calm/mindful pause)*

## Age rating

- Expected **4+** because the current product has no known objectionable
  content. Complete Apple's current questionnaire field by field and accept the
  result; do not mechanically answer "None" or force a desired rating.

## Privacy (App Privacy "nutrition label")

- **Data Not Collected.** Anjali collects no data and makes no network
  requests. See `privacy_policy.md`.
- No tracking; no third-party SDKs.

## Export compliance

- **Uses non-exempt encryption: No.** The app makes no network calls and uses
  no encryption beyond what Apple's OS provides. Set
  `ITSAppUsesNonExemptEncryption = NO` (Info.plist) to skip the prompt.

## What's New (v1.0)

```
The first Anjali: one contextual prayer for the moment, self-led Chant and
Silent modes, five times of day, browse by Moment, Intention, or Deity, and
editable optional reminders. Fully offline and private.
```

---

### Notes for the listing author
- The description says "chosen for the moment," **not** "recommendations" — this
  is deliberate. Anjali's product principle is *no recommendation engine*; keep
  marketing language aligned with that (no "for you," no "feed," no "discover
  more").
- Normal builds contain no provisional generated/TTS audio and hide Listen.
  Keep all audio claims out of the submitted listing until an exact, reviewed
  human recording actually ships for the advertised prayer.
- Do not submit this listing while named cultural/theological review remains
  0/22 or required manual device/accessibility gates remain pending.
- Store screenshots and most platform-version metadata are App Store submission
  work, not prerequisites for the first internal TestFlight install. See
  `testflight_metadata.md` for beta-specific copy.
