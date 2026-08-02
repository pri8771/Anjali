# Prayer Content Review Checklist

Work through this before changing a prayer's `review_status` to `reviewed`, and
again before it is `approved_for_release` (bundled). The guiding rule from
[`../CONTENT_GUIDELINES.md`](../CONTENT_GUIDELINES.md): **never fabricate
Sanskrit.** If anything is uncertain, leave `needs_review = true` and do not
bundle.

## 1. Source verification
- [ ] The mantra is a **well-known, attested** text — not generated or invented.
- [ ] `source_title` names a precise citation where possible (e.g. *Ṛgveda
      3.62.10*), or honestly says "traditional" with the tradition named
      (Śaiva, Bhāgavata, etc.).
- [ ] `source_note` captures anything a reader should know (alternate
      attributions, scope of the excerpt).
- [ ] No claim of guaranteed outcomes or sectarian superiority.

## 2. Sanskrit & transliteration
- [ ] Devanagari (`primary_text`) verified character-by-character against a
      trusted source.
- [ ] Transliteration is **IAST** and consistent (`ṃ`, `ṛ`, `ś`, `ṣ`, `ā`, …).
- [ ] Line breaks / daṇḍa (`।`, `॥`) match the source.
- [ ] `short_title` reads cleanly and isn't misleading.

## 3. Meaning
- [ ] Translation is faithful, plain, and brief (a sentence or two).
- [ ] No embellishment or claims the text does not make.

## 4. Classification
- [ ] `deity` is correct (or blank for a universal mantra).
- [ ] `moments`, `intentions`, `time_contexts` are accurate and use valid enum
      values.
- [ ] `rotation_policy` is appropriate — `dailyAnchor` only for true daily
      staples; `occasional` for special-intention prayers; otherwise
      `rotateOften`.
- [ ] `duration_seconds` is realistic for an unhurried recitation (10–60s);
      set `timing_status = measured` once timed against audio.

## 5. Regional variants
- [ ] `regional_note` records meaningful regional/sampradāya differences in
      wording or pronunciation, where they exist.
- [ ] The chosen form is a widely-accepted one; alternatives are noted, not
      silently dropped.

## 6. Audio (only if a recording exists)
- [ ] Discovered/rejected material is tracked honestly in
      `audio_candidate_manifest.csv`; a proposed shipping clip is tracked in
      `audio_manifest_template.csv` with a `recording_status`.
- [ ] The proposed consumer clip is a recording of a real, identified human
      performer. It is not TTS, synthetic speech, generated singing, or a
      generated recitation.
- [ ] Asset basename exactly equals the canonical prayer ID; no sibling,
      same-deity, theme, or fuzzy-title substitution is used.
- [ ] A verbatim heard transcript records all words, omissions, additions,
      refrains, ordering, and repetitions and matches the approved sacred text.
- [ ] Pronunciation reviewed by a qualified `pronunciation_reviewer`.
- [ ] Source, creator/performer, consent, license, allowed distribution, exact
      SHA-256, and durable rights evidence are recorded.
- [ ] Tempo, instrumentation, mood, duration, and repetition are appropriate for
      the prayer's configured moments and time contexts.
- [ ] Audio is clean: no clipping, even levels, minimal noise, natural pacing.
- [ ] `duration_seconds` re-measured against the clip.
- [ ] Any timing sidecar was measured from this exact hash, covers every heard
      repetition, and matches canonical lines without estimated timestamps.
- [ ] `approved_by` set; `bundled` flipped only when the asset is in the app.
- [ ] Normal Debug, physical-device, Release, TestFlight, and App Store builds
      contain no unapproved synthetic/TTS/Suno fixtures.
- [ ] If an unapproved fixture must be exercised for isolated engineering QA,
      both `DEBUG` and `ENABLE_UNAPPROVED_AUDIO_PREVIEW` are set and the fixture
      is deliberately bundled by that QA scheme only. `DEBUG` alone is
      insufficient.
- [ ] Listen is hidden when the exact approved recording does not resolve.
- [ ] App still works with audio **removed** through Chant and Silent without
      claiming that sound played.

## 7. Final approval
- [ ] `review_status = reviewed`, `needs_review = false`, and
      `reviewer_name` names the real human reviewer.
- [ ] The canonical JSON has the same real name in `provenance.reviewer` and
      the actual ISO review date in `provenance.reviewedOn`.
- [ ] `python3 Scripts/validate_prayers.py --require-signoff` passes for the
      final review commit.
- [ ] Row is internally consistent (no enum typos, no empty required fields).
- [ ] After bundling into `prayers.json`:
      `python3 Scripts/validate_prayers.py` passes.
- [ ] The exact hash was spot-checked in the app (Today card + full-screen
      player) on the physical target device, including audible words,
      repetitions, displayed lyrics, pause/resume, and route changes.
