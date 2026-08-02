# Anjali — Audio Recording Specification

This defines how recitation audio is produced for Anjali. Audio is **optional**
and **local only** in v1. When no approved recording exists, Listen is hidden
and the prayer remains available through the text-led Chant and Silent modes.
Read
[`../CONTENT_GUIDELINES.md`](../CONTENT_GUIDELINES.md) first: pronunciation must
be reviewed by a qualified reviewer **before** recording.

## TestFlight-pilot and consumer-build policy

The current repository files are forensic candidates, not approved consumer
audio. The local audit found no recording with a documented human performer,
exact heard transcript, distribution rights, hash-bound cultural/pronunciation
approval, and device QA. The macOS Lekha files are synthetic TTS, and the
Digital Temple files are Suno-generated music.

**Owner decision (2 August 2026):** a bounded TestFlight pilot may bundle the
selected Suno-generated tracks solely to test playback and product usability.
This is not a claim that the tracks are human, culturally/pronunciation
reviewed, lyric-perfect, or ready for public release. The pilot build must
visibly label Listen audio as experimental generated audio and preserve the
canonical text, transliteration, and meaning as the source of truth. App Store
and public-release builds remain subject to the full human-recording gate below.

- The TestFlight pilot uses exact-ID-only selected Suno files, with one file per
  prayer and no fuzzy/deity/moment substitution.
- The pilot's 20 selected tracks are AAC/M4A. `ganesha-vakratunda` and
  `shanti-asato-ma` temporarily use their exact-ID MP3 candidates while their
  replacement generations are pending; this exception is TestFlight-only and
  must not be carried into a public build.
- Every pilot asset must be recorded in the candidate manifest with source,
  hash, generation title, known limitations, and the explicit `testflight_pilot`
  release policy.
- Normal public/App Store builds use the approved human-recording catalog.
- Stale DerivedData is not evidence. Verify a clean `.app` bundle and the
  visible experimental-audio disclosure before pilot distribution.

Synthetic speech, generated singing, and generated recitation are not accepted
as public consumer recordings even if they sound human-like or use the correct
input text. The narrowly disclosed TestFlight pilot exception above does not
change the public-release acceptance standard.

## Technical format

| Property | Value |
| --- | --- |
| Container / codec | **AAC in `.m4a`** |
| Sample rate | **44.1 kHz** |
| Channels | **Stereo** |
| Target loudness | **−16 LUFS** (integrated) |
| True peak | ≤ −1 dBTP |
| Duration | **10–60 seconds** (matches `durationSeconds`) |
| Leading/trailing silence | trimmed to **< 0.3 s** each side |
| Background music | **None in v1** |

## Recording guidance

- **One clean human voice per prayer.** No layering, no music bed, no reverb
  wash. A small natural room tone is fine; aim for clarity over production.
- **Pronunciation reviewed before recording** (see the content review
  checklist). Re-record rather than "fix in post" for mispronunciations.
- Even pacing — unhurried but within the duration budget.
- Edit out clicks, breaths that distract, and long gaps; keep the natural
  rhythm of the mantra.
- Normalise to the loudness target so every prayer feels level in the player.

## Optional bells

A prayer may be topped/tailed with a soft bell. Bells are **separate, shared
assets** (not baked into each recitation), so they can be reused and toggled:

- `bell_start.m4a` — a single soft strike to open.
- `bell_end.m4a` — a single soft strike to close.

Same technical format as above. Keep them short (~1–2 s) and gentle. v1 may ship
without bells; the recitation file alone is sufficient.

## File naming

| File | Meaning |
| --- | --- |
| `prayerID.m4a` | The recitation for that prayer (e.g. `ganesha-gam.m4a`). |
| `prayerID_timing.json` | *Optional* per-line timing for highlight/sync. |
| `bell_start.m4a`, `bell_end.m4a` | Shared optional bells. |

`prayerID` must exactly match the `id` in `prayers.json`. A consumer recording
is enabled only by setting that prayer's `audioAssetName` to `prayerID` and
deliberately bundling the approved `.m4a`. The resolver can recognize additional
formats for isolated QA fixtures, but consumer audio must use `.m4a`. When the
exact approved asset is absent, the UI omits Listen; a forced or stale Listen
request fails truthfully instead of starting pretend playback.

### Audio-to-text identity

- Playback resolves only `Audio/<prayerID>.<extension>` for the prayer currently
  displayed. Never substitute another prayer because it has the same deity,
  theme, moment, or title fragment.
- More than one supported extension for the same prayer ID is ambiguous and
  must fail closed.
- A filename, source-catalog verse, prompt, or matching title does not prove the
  recording's audible words. Before approval, create a verbatim heard
  transcript containing every invocation, repetition, refrain, omission, and
  added line, then compare it with the canonical Devanagari and IAST.
- When a recording repeats the canonical prayer, record its exact order and
  count. The UI/timing data must represent those repetitions or the asset
  remains an unsynchronized internal candidate.
- Do not change canonical sacred text solely to fit an available recording. A
  proposed textual variant returns to the content-review workflow.
- Missing, partial, mismatched, ambiguous, or undecodable audio must not expose
  Listen. A forced or stale player request must show an unavailable-audio
  message while leaving Chant and Silent usable.

## Timing JSON schema (optional)

Used later for line-by-line highlighting. An array of line spans, in order:

```json
[
  { "line": "ॐ गं गणपतये नमः", "startSeconds": 0.0, "endSeconds": 4.2 },
  { "line": "ॐ गं गणपतये नमः", "startSeconds": 4.2, "endSeconds": 8.4 }
]
```

| Field | Type | Notes |
| --- | --- | --- |
| `line` | string | The text line (Devanagari), matching the prayer's text. |
| `startSeconds` | number | Start offset, seconds from the audio start. |
| `endSeconds` | number | End offset; must be ≥ `startSeconds`. |

Spans should be measured from the exact reviewed audio, ordered,
non-overlapping, and tied to the immutable asset SHA-256. The field is optional
in v1; absent or invalid timing means static lyrics with no synchronized
highlight. Never estimate spans by dividing duration or counting characters.

## Pipeline placement

Recording sits in the **audio-ready** stage of the content lifecycle
([`README.md`](README.md)). Track each clip in
[`audio_manifest_template.csv`](audio_manifest_template.csv): `recording_status`,
`pronunciation_reviewer`, `edit_notes`, `approved_by`, `bundled`. Only flip
`bundled` once all of the following refer to the same immutable SHA-256:

1. approved canonical Devanagari and IAST revision;
2. verbatim heard transcript and repetition order;
3. named human cultural/pronunciation reviewer and review date;
4. human performer, consent, license, and durable distribution-rights proof;
5. technical conformance report and any measured timing sidecar; and
6. successful playback/lyrics QA on the physical target device.

Keep discovered and rejected files in
[`audio_candidate_manifest.csv`](audio_candidate_manifest.csv) without
converting their presence into bundle eligibility. A later byte change
invalidates the hash-bound approvals and requires re-review.

The detailed execution and approval path is
[`../docs/AUDIO_LYRIC_ALIGNMENT_PLAN.md`](../docs/AUDIO_LYRIC_ALIGNMENT_PLAN.md).
