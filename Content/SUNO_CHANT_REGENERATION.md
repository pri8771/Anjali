# Suno chant regeneration batch — owner direction 2026-08-14

Owner device review of build 3 (iPhone 16 Pro Max): the pilot audio does not
support the product. "The music sounds so slow… it should feel more like a
chant." Direction: **replace every pilot track that is not a chant with one
that is.** All eight current pilot MP3s fail this standard — they are produced
songs (song intro, instrumentation, genre production), not chants.

## The chant standard (acceptance criteria for every regenerated track)

1. **Voice-forward.** A single clear voice (or small unison group) chanting the
   exact prayer text. No lead instruments, no melody hooks, no beat drops.
2. **No intro.** The voice begins within the first 2 seconds.
3. **Steady chant cadence.** Even, repeatable pacing a listener can join —
   the cadence of temple japa, not a ballad tempo.
4. **Repetition with breath gaps.** The mantra repeats N times with a natural
   breath pause between repetitions. Nothing else happens in the gaps
   (silence or a low tanpura drone only).
5. **Exact text.** The generated audio must contain only the prayer's words —
   the same words shown on screen, the same number of display repetitions or a
   clean multiple of them.
6. **Duration disciplined.** Close to the catalog `durationSeconds` or a clean
   multiple (e.g. 3 repetitions ≈ 36s for a 12s prayer). Not a 58-second song
   for a 12-second prayer.
7. **Variant styles are chant variations, not genres.** All three versions
   must still be chants. They differ in texture, never in category:
   - **v01 (in-app label "Default"):** voice + silence, or voice + soft
     tanpura drone. The reference chant.
   - **v02 (in-app label "Version 1"):** small unison group chant, gentle
     call-and-response feel, light drone.
   - **v03 (in-app label "Version 2"):** deeper solo voice, slower meditative
     pace, longer breath gaps.
   The old genre variants (energy-EDM, deep-Indian-hip-hop) are retired.

## Why the current files fail

| File | Duration | Catalog duration | Verdict |
|---|---|---|---|
| ganesha-gam__v01-traditional.mp3 | 58.0s | 12s | Produced song; fails 2, 3, 6 |
| ganesha-gam__v02-energy-edm.mp3 | 49.8s | 12s | EDM production; fails 1, 3, 6, 7 |
| ganesha-gam__v03-deep-indian-hip-hop.mp3 | 35.6s | 12s | Hip-hop production; fails 1, 7 |
| ganesha-shri__v01-traditional.mp3 | 12.1s | 10s | Closest fit; re-verify against 1–4 |
| ganesha-shri__v02-energy-edm.mp3 | 41.6s | 10s | Fails 1, 3, 6, 7 |
| ganesha-shri__v03-deep-indian-hip-hop.mp3 | 31.0s | 10s | Fails 1, 7 |
| vishnu-shantakaram__v01-traditional.mp3 | 39.4s | ~30s | Song production; fails 2, 3 |
| vishnu-shantakaram__v02-energy-edm.mp3 | 37.4s | ~30s | Fails 1, 3, 7 |
| ganesha-vakratunda.mp3 (base) | 19.0s | 15s | Re-verify against standard |
| shanti-asato-ma.mp3 (base) | 25.7s | 20s | Re-verify against standard |

## Suno prompts (paste per track; put the prayer text in the Lyrics field)

Shared style stem — append the per-version texture:

> Sacred Sanskrit chant, a cappella devotional japa, single clear voice
> chanting steadily with natural breath pauses between repetitions, no
> instruments except an optional soft tanpura drone, no intro, no melody,
> no percussion, temple atmosphere, recorded close and warm, begins
> immediately.

Per-version texture:
- **v01 Default:** "solo voice, silence between repetitions"
- **v02 Version 1:** "small unison group, gentle call-and-response, soft continuous tanpura"
- **v03 Version 2:** "deep low solo voice, slow meditative pace, long breath gaps, faint drone"

Lyrics field per prayer (repeat the line; use `[pause]`-style line breaks between repetitions):

1. **ganesha-gam** — `Om Gam Ganapataye Namah` ×3 (~36s target)
2. **ganesha-shri** — `Om Shri Ganeshaya Namah` ×3 (~30s target)
3. **vishnu-shantakaram** — the full verse once, chanted evenly (~30s):
   `Shantakaram Bhujagashayanam Padmanabham Suresham / Vishvadharam Gaganasadrisham Meghavarnam Shubhangam / Lakshmikantam Kamalanayanam Yogibhir Dhyanagamyam / Vande Vishnum Bhavabhayaharam Sarvalokaikanatham`

File naming on export (unchanged scheme, so the resolver keeps working):
`<prayer-id>__v01-traditional.mp3`, `__v02-energy-edm.mp3`,
`__v03-deep-indian-hip-hop.mp3` — the file *suffixes* keep their historical
names; the in-app labels are now Default / Version 1 / Version 2.
(Rename the suffixes only together with `PrayerAudioAssetResolver.fileSuffix`.)

## Do all 22 prayers need chant audio?

Recommendation: **no.**
- **Chant mode needs no audio by design** — it is self-led; the person is the
  voice. This does not change.
- **Listen mode** is where audio lives. Roll it out in tiers:
  - Tier 1 (pilot, now): the 3 prayers above, regenerated to the chant standard.
  - Tier 2: the short japa-style prayers (vakratunda, shiva, narayana,
    vasudeva, mahamrityunjaya, saraswati, lakshmi, hanuman ×2, surya ×2,
    devi ×2, maha-mantra) — same standard, ×3 repetitions each.
  - Tier 3 (verse prayers, e.g. the five shanti prayers): single clean
    recitation at natural verse pace — a chant loop fits these poorly.
- Every track remains TestFlight-pilot-only generated audio under
  DEC-014/DEC-015 until replaced by approved human recordings.

## Process

1. Generate v01/v02/v03 per prayer in Suno (prompts above).
2. Verify each file against the 7-point standard; measure duration with
   `afinfo`; reject and retry any track with an intro or instrumentation.
3. Replace files in `Anjali/Anjali/Resources/PilotAudio/`, update
   `Content/pilot_audio_variants_manifest.csv` (new SHA-256, duration,
   generation title), bump build, upload build 4.
