# Anjali — Content Pipeline

This folder is where prayer content is authored and reviewed **before** it is
hand-curated into the app's bundled `Anjali/Anjali/Resources/prayers.json`.
It is a working area for editors and reviewers — the app does not read these
files at runtime.

> Read [`../CONTENT_GUIDELINES.md`](../CONTENT_GUIDELINES.md) first. The single
> most important rule: **never fabricate Sanskrit.** Only well-known, attested
> mantras with honest source notes.

## The lifecycle of a prayer

```
draft  →  reviewed  →  audio-ready  →  bundled
```

1. **draft** — An editor adds a row to `prayer_catalog_seed.csv` (or a working
   copy) using `prayer_catalog_template.csv` as the column reference. Text,
   transliteration, meaning, deity, moments, etc. are filled in.
   `review_status = draft`, `needs_review = true`.

2. **reviewed** — A named knowledgeable human reviewer works through
   [`content_review_checklist.md`](content_review_checklist.md): verifies the
   source, checks the Devanagari and IAST transliteration, confirms the meaning,
   and notes any regional variants. When satisfied they set
   `review_status = reviewed`, `needs_review = false`, and record their name in
   `reviewer_name`. Only `reviewed` prayers may be bundled.

3. **audio-ready** *(optional)* — If a recitation is recorded, it is tracked in
   an actual manifest derived from `audio_manifest_template.csv` (one row per
   clip). Candidate/source forensics currently live in
   `audio_candidate_manifest.csv`. Pronunciation, verbatim heard words and
   repetitions, context, rights, immutable hash, technical mastering, timing,
   and device playback are reviewed before `audio_status` or
   `audio_asset_name` changes. Audio is always optional — a prayer ships fine
   without it and the player falls back to a timed text experience.

4. **bundled** — Approved rows are converted into entries in `prayers.json`.
   Run both the structural and named-signoff validators before release:
   `python3 Scripts/validate_prayers.py` and
   `python3 Scripts/validate_prayers.py --require-signoff` from the repository
   root.

## Files

| File | Purpose |
| --- | --- |
| `prayer_catalog_template.csv` | Empty CSV with the canonical column headers. Copy it to start fresh. |
| `prayer_catalog_seed.csv` | The current 22 bundled prayers, exported from `prayers.json`. The source of truth editors expand. |
| `audio_manifest_template.csv` | Empty CSV for tracking recorded audio per prayer. |
| `audio_candidate_manifest.csv` | Current 22-prayer forensic ledger; candidates are not approvals. |
| `content_review_checklist.md` | Step-by-step review before a prayer is approved for release. |
| `hero_prayers.md` | Priority, coverage, and provisional-source status. |
| `audio_spec.md` | Exact-ID, recording, transcript, technical, and timing rules. |

## Catalog columns

`id, title, short_title, deity, moments, intentions, time_contexts,
duration_seconds, rotation_policy, available_modes, primary_script,
primary_text, transliteration, meaning, source_title, source_note,
regional_note, reviewer_name, review_status, needs_review, audio_status,
audio_asset_name, timing_status, tags, sort_order`

- **Multi-value cells** (`moments`, `intentions`, `time_contexts`,
  `available_modes`, `tags`) use a semicolon `;` separator, e.g.
  `dawn;morning`.
- Enum values must match the Swift enums in
  `Anjali/Anjali/Models/Enums.swift`:
  - `deity`: ganesha, shiva, vishnu, krishna, hanuman, devi, lakshmi,
    saraswati, surya (or blank for universal mantras)
  - `moments`: dawn, leavingHome, beforeWork, meeting, study, travel, anxiety,
    gratitude, protection, sunset, sleep
  - `time_contexts`: dawn, morning, midday, sunset, night
  - `available_modes`: listen, chant, silent
  - `rotation_policy`: dailyAnchor, rotateOften, occasional, festivalSpecific
- `review_status`: draft | reviewed
- `audio_status`: none | recording | recorded | approved
- `timing_status`: estimated | measured

## Regenerating the seed

`prayer_catalog_seed.csv` is generated from the bundled JSON so the two never
drift:

```bash
python3 Scripts/export_catalog.py     # run from the repo root
```

## Scope note

This pass establishes the pipeline only. The bundled set stays at 22
structurally valid prayers. Its imported `isReviewed` flags do not replace
named human provenance: as of 29 July 2026, the release gate is 0/22 signed and
correctly blocks. Expansion happens only in a later reviewed content pass
through this exact workflow.

Audio/lyric remediation and future enablement follow
[`../docs/AUDIO_LYRIC_ALIGNMENT_PLAN.md`](../docs/AUDIO_LYRIC_ALIGNMENT_PLAN.md).
Source projects remain read-only; copy accepted assets with source/destination
hash evidence and never move them.
