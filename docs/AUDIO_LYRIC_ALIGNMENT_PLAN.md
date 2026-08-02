# Audio and Lyric Alignment Plan

Last updated: 30 July 2026  
Owner: engineering + named content/pronunciation reviewer  
Status: `verification_pending`

## Outcome and non-negotiable rules

Anjali must never play one prayer while displaying another prayer's text. An
audio asset is eligible only when its spoken words, repetitions, ordering,
prayer identity, context, provenance, and rights have been checked against the
canonical record in `Anjali/Anjali/Resources/prayers.json`.

- The repository is the source of truth. Jira and Notion may only mirror this
  plan.
- An asset basename must equal the displayed `Prayer.id`. A related deity,
  theme, title, or moment is not a substitute.
- Source projects are read-only. Assets may be copied into Anjali staging; they
  must never be moved, renamed in place, or deleted from their source.
- Filenames, catalog lyrics, hashes, and generated prompts are useful evidence,
  but do not prove what is audibly present.
- Generated, TTS, unlicensed, untranscribed, or unreviewed assets remain
  excluded from public/App Store builds. Per DEC-014, a bounded TestFlight
  pilot may bundle selected Suno-generated assets only with exact-ID matching,
  source/hash documentation, and a visible experimental-audio disclosure.
- Public-release Listen remains hidden until an exact human recording has
  rights clearance, hash-bound cultural/pronunciation approval, technical
  evidence, and physical-device QA.
- Sacred text is not changed merely to fit an available recording. A proposed
  text variant returns to content review.
- Timing data is measured from an accepted recording. Agents must not estimate
  word or line timings.

## Current finding

The former mismatches were real and the cross-prayer substitutions have been
removed: `vishnu-shantakaram` never resolves `vishnu-narayana`, and
`hanuman-manojavam` never resolves `hanuman-namah`. The
`shanti-asato-ma` source catalog still includes an opening Oṃ and closing
triple Śānti that the Anjali record does not display. Eleven TTS files were
generated from the correct text but repeat it three to seven times; nine Suno
files have matching catalog subjects but no verbatim heard transcript or
approval.

The expanded local search inspected all accessible project audio, including
Digital Temple and Svara, plus the surviving Downloads package. It found no
recording with a documented human performer, consent, distribution license,
pronunciation review, heard transcript, and device approval. Digital Temple's
29 exact-title candidates across ten Anjali prayer identities are all
Suno-generated; Svara is derivative and includes false thematic mappings.
Therefore none of the audited files is a suitable consumer or device-preview
recording.

The current implementation excludes all repository audio through target
membership, leaves every catalog `audioAssetName` null, applies the
approved-catalog resolver policy to normal Debug/device/Release builds, and
hides Listen. The repository files remain forensic evidence. Unit tests inject
temporary fixtures; a deliberate QA scheme must both bundle a fixture and set
`ENABLE_UNAPPROVED_AUDIO_PREVIEW`.

The detailed ledger is `Content/audio_candidate_manifest.csv`; audit evidence
is `quality/evidence/2026-07-29-audio-lyrics-source-audit.md`.

## Task order

```text
ALA-001 audit ─┬─> ALA-002 exact-ID playback ─> ALA-003 quarantine
               └─> ALA-004 human transcript/review ─> ALA-005 acquire/copy
ALA-003 + ALA-005 ─> ALA-006 measured timing ─> ALA-007 automated gates
ALA-002..007 ─> ALA-008 canonical docs/release policy ─> ALA-009 device sign-off
```

## ALA-001 — Establish the canonical asset-to-prayer audit

**Status:** `code_complete`; human recording acquisition and review remain
pending.

This task inventories every prayer and candidate so engineering can distinguish
an exact recording from a same-title, same-deity, or same-theme file. The
expected change is a durable 22-row ledger containing canonical ID, asset,
source path/project, SHA-256, duration, source type, lyric-match classification,
repetition structure, context suitability, rights, pronunciation, technical
status, and Debug/Release policy.

### ALA-001.1 — Inventory the current Anjali assets

List every file under `Anjali/Anjali/Resources/Audio`, calculate SHA-256, and
measure duration/format with `afinfo`. Join each basename to exactly one
`prayers.json` ID. Record missing IDs and duplicate extensions. Do not infer a
match from a filename.

**Expected result:** 20 files map structurally to 20 IDs; two IDs have no
same-ID file. Evidence records exact commands and output.

### ALA-001.2 — Trace source provenance without modifying source projects

Search Digital Temple, Svara, and other local projects for identical hashes,
catalog rows, prompts, lyrics, provenance, rights, and review records. Record
absolute source paths. If an asset is uniquely useful, copy it only to a
non-shipping staging directory and record source/destination hashes; otherwise
do not duplicate an existing Anjali file.

**Expected result:** the nine Anjali MP3s trace to Digital Temple Suno assets;
Svara is documented as a derivative source, not an independent approval source.

### ALA-001.3 — Classify evidence honestly

Use `exact-input`, `partial`, `mismatch`, `unverifiable`, or `missing`.
`exact-input` means the generation/recording input matches canonical text; it
does not mean pronunciation is approved. `unverifiable` means catalog subject
or lyrics exist but nobody has produced a verbatim heard transcript. Record
context as suitable, questionable, or unsuitable separately from text match.

**Expected result:** no row claims audible correctness, license, pronunciation,
or cultural approval without named evidence.

## ALA-002 — Enforce exact-ID-only playback

**Status:** `code_complete`; device verification pending.

This task removes code paths that can play a related prayer and replaces fuzzy
bundle searching with a deterministic resolver. Listen is offered only when
the exact approved recording resolves; otherwise the prayer remains text-led.

### ALA-002.1 — Remove cross-prayer fallbacks

Delete the mappings from `vishnu-shantakaram` to `vishnu-narayana` and from
`hanuman-manojavam` to `hanuman-namah`. Do not replace them with another deity,
theme, or fuzzy-name lookup.

**Expected result:** both prayers remain text-only until exact same-ID assets
exist.

### ALA-002.2 — Add a deterministic resolver

Resolve only `Audio/<prayer.id>.<supported extension>`. A null
`audioAssetName` may preview the same ID only in a build compiled with both
`DEBUG` and `ENABLE_UNAPPROVED_AUDIO_PREVIEW`. All normal builds require the
approved catalog name to equal the prayer ID. Fail closed when no asset exists,
more than one extension exists, or the catalog name differs. Do not recursively
enumerate the bundle.

**Expected result:** the player cannot accidentally select a sibling or stale
file, normal builds remain text-only under the current catalog, and `DEBUG`
alone cannot expose unapproved audio.

### ALA-002.3 — Add regression tests

Test exact resolution, missing asset, duplicate extensions, mismatched catalog
name, null-catalog Debug preview, Release rejection, and explicit Vishnu/Hanuman
non-substitution cases. Use temporary directories and injected policy; do not
depend on the developer's bundle.

**Expected result:** a future same-deity fallback or ambiguous asset causes a
test failure.

## ALA-003 — Quarantine mismatched and unverifiable preview audio

**Status:** `code_complete`; human listening review remains pending.

Exact filenames alone do not make the current Suno catalog safe. This task
defines how provisional files remain inaccessible to consumer builds while
retaining every source file in place. The expected change is explicit target
exclusion plus a separately configured QA-only opt-in; no file is moved or
deleted.

### ALA-003.1 — Block known mismatches

Exclude `shanti-asato-ma` until the heard audio and canonical text use the same
opening/closing form. Keep `vishnu-shantakaram` and `hanuman-manojavam`
unavailable because no exact files exist.

**Expected result:** no known partial or wrong prayer plays in a normal Debug
or consumer build.

### ALA-003.2 — Separate fixtures from consumer audio

Keep the 11 known-input TTS files labeled as test evidence only and keep every
Suno track disabled. Neither source type may become consumer audio. Unit tests
use injected temporary fixtures. If isolated engineering QA needs a repository
file, use a dedicated scheme that deliberately bundles only the selected file
and defines `ENABLE_UNAPPROVED_AUDIO_PREVIEW`; never modify normal target
membership or normal Debug settings.

**Expected result:** normal Debug and physical-device builds behave like the
consumer product, while an explicit QA build cannot be mistaken for an
approved preview.

### ALA-003.3 — Preserve normal-build isolation

Clean-build normal Debug and Release and inspect each `.app` for audio
extensions, provisional manifests, and timing sidecars. The count must remain
zero until ALA-009 enables a reviewed human recording. Also assert that
`ENABLE_UNAPPROVED_AUDIO_PREVIEW` is absent from normal schemes and archive
settings.

**Expected result:** stale DerivedData and private QA changes cannot leak into
a device install or TestFlight.

## ALA-004 — Produce verbatim listening and approval evidence

**Status:** `blocked_on_human_recording_and_reviewer`.

Automated inspection cannot confirm Sanskrit pronunciation, repetition order,
musical appropriateness, or rights. The current TTS/Suno set is rejected for
consumer use by source type. After an exact human recording is acquired, a
named qualified reviewer must listen while viewing the approved Devanagari and
IAST.

### ALA-004.1 — Create a heard transcript

For every candidate, write the words in heard order, including invocations,
repetitions, refrains, omitted lines, added lyrics, bells, and instrumental
sections. Mark uncertain timestamps rather than guessing. Compare the transcript
line by line to `prayers.json`.

**Expected result:** every enabled candidate has an auditable `exact`,
`accepted-variant`, or `rejected` disposition.

### ALA-004.2 — Review pronunciation and sacred-text variant

Have the named content/pronunciation reviewer verify syllables, sandhi, Vedic or
sectarian pronunciation where applicable, and whether any variant is acceptable.
Record reviewer, date, exact SHA-256, prayer ID, decision, and corrections. A
model may prepare the packet but may not sign it.

**Expected result:** approval applies to one immutable asset hash and one
canonical text revision.

### ALA-004.3 — Review context and musical treatment

Evaluate whether tempo, instrumentation, mood, length, and repetitions fit the
prayer's moments and time contexts. Reject distracting, theatrical, EDM,
sleep-inappropriate, or overly long treatments for the micro-prayer use case.

**Expected result:** the asset is appropriate for where and when Anjali surfaces
it, not merely related to the same deity.

### ALA-004.4 — Establish rights

Record creator/performer, consent, source, license, permitted app/TestFlight/App
Store distribution, and durable proof. Generated-service provenance must also
be reviewed by the owner. Unknown or pending rights means no distribution.

**Expected result:** every shipping asset has reviewable distribution authority.

## ALA-005 — Acquire or copy exact accepted recordings

**Status:** `pending`; depends on ALA-004.

The local audit found no suitable human recording, so this task fills genuine
coverage gaps by commissioning or otherwise acquiring one clean, immutable
same-ID human recording per selected prayer. Copy an accepted external source
into Anjali without altering its source project.

### ALA-005.1 — Select coverage

Prioritize the 20 hero prayers in `Content/hero_prayers.md`; the two deferred
long ślokas remain text-only unless exact recordings are accepted. Do not use a
sibling prayer to manufacture coverage.

### ALA-005.2 — Copy with provenance

Copy the accepted source file, verify source and destination SHA-256, and record
both absolute paths. Record the human performer, consent, recording date,
license, and durable distribution proof before app integration. Convert/master
only into a new derived file, preserving the original. Name the app candidate
exactly `<prayerID>.m4a`.

### ALA-005.3 — Meet the audio specification

Produce AAC `.m4a`, 44.1 kHz stereo, −16 LUFS integrated, ≤ −1 dBTP, trimmed
silence, clean human voice, no background music for v1, and a 10–60 second
micro-prayer duration unless product/content explicitly changes the scope.

**Expected result:** accepted files satisfy content, context, rights, and
technical checks without destructive source operations.

## ALA-006 — Add measured line synchronization

**Status:** `pending`; do not start timing an unaccepted asset.

This task makes Listen mode follow the actual recording. The expected change is
optional `<prayerID>_timing.json` data tied to the exact audio hash and line
highlighting that fails safely when data is absent or invalid.

### ALA-006.1 — Implement the versioned timing model

Store schema version, prayer ID, audio asset name, audio SHA-256, measured audio
duration, and ordered line spans with canonical Devanagari text. Validate exact
ID/hash/text, finite nonnegative values, increasing non-overlapping spans,
duration tolerance, line coverage, and allowed full-prayer repetition cycles.

### ALA-006.2 — Measure spans

Measure timestamps by listening to the immutable accepted recording. Include
every repetition; do not divide duration evenly or estimate from character
count. A gap may have no active line.

### ALA-006.3 — Render synchronized text accessibly

Highlight the active Devanagari and matching transliteration line by index.
Use a non-color cue and accessible current-line value. If line counts differ or
timing is invalid, show static lyrics and the truthful caption “Lyrics are
shown without synchronized highlighting.” Never announce changes every timer
tick.

**Expected result:** valid timing follows audio; invalid/missing timing cannot
mislead or prevent exact audio from playing.

## ALA-007 — Add automated audio integrity gates

**Status:** `pending`.

This task prevents recurrence before build/device QA. The expected change is a
standard-library validator plus unit/UI coverage wired into local and CI gates.

### ALA-007.1 — Add `Scripts/validate_audio.py`

Validate exact ID mapping, duplicate formats, manifest status, SHA-256, `afinfo`
duration, timing schema/spans, and Devanagari/transliteration line counts.
`--preview` is available only to the explicit QA configuration and reports
provisional status honestly. Normal Debug and `--release` reject unapproved
audio; release additionally requires `.m4a`, a documented human performer,
named pronunciation reviewer/approver, rights proof, `bundled=true`, exact
catalog reference, and approved content provenance.

### ALA-007.2 — Add model/controller/view tests

Cover timing boundaries/gaps/repetitions; resolver fail-closed behavior; Listen
audio clock; Chant/Silent no-audio behavior; reset/mode changes; both script
preferences; Dynamic Type; accessibility; missing audio; and invalid timing.

### ALA-007.3 — Extend normal-build inspection

Fail the normal Debug or Release gate if unapproved audio, preview manifests,
timing sidecars, or the QA compilation condition enter the bundle/configuration.
Preserve the current zero-audio rule until ALA-009 changes it with explicit
evidence.

## ALA-008 — Synchronize canonical documentation and contracts

**Status:** `code_complete`; continue synchronizing when later tasks change.

This task keeps implementation, tester claims, and release gates consistent.
Update this plan first, followed by `Content/audio_spec.md`, the actual candidate
manifest, `Content/README.md`, `Content/hero_prayers.md`,
`Content/content_review_checklist.md`, `docs/ARCHITECTURE.md`,
`docs/FEATURES.md`, `docs/DECISIONS.md`, `docs/BUGS.md`, `docs/TEST_PLAN.md`,
`docs/STATUS.md`, FEAT-001, release checklists, and TestFlight task text.

**Expected result:** no document says audio is exact, approved, synchronized, or
shipping before its evidence exists; Jira/Notion mirrors can be regenerated
from the repo.

## ALA-009 — Verify on iPhone and enable only approved audio

**Status:** `pending`.

This task proves audible behavior on the actual distribution path. The expected
change is device evidence per approved human recording and, only after every
approval, an intentional catalog/membership change.

### ALA-009.1 — Run engineering checks

Run prayer/audio validators, unit/integration/UI tests, a normal Debug device
build, and unsigned Release inspection. Confirm that both normal app bundles
contain zero audio while the current catalog is unapproved. Preserve command
output and the exact commit/build.

### ALA-009.2 — Execute the listening matrix

On the iPhone 16 Pro Max, test every enabled human recording in Listen; compare
all heard words/repetitions and highlights to the displayed Devanagari and
transliteration.
Also test pause/resume, route/volume, mode switch, script switch, background/
foreground, unavailable audio, and completion timing.

### ALA-009.3 — Obtain named sign-off

Engineering records playback correctness; content/pronunciation records sacred
text correctness; rights owner records distribution authority; QA records
device/build results. Failures return to ALA-004 or ALA-005.

### ALA-009.4 — Enable Release assets deliberately

For approved human-recording hashes only, set the exact `audioAssetName`, update
the manifest, bundle membership, release gate, TestFlight metadata, and
evidence together. Rebuild and inspect the final candidate. Any later byte
change invalidates timing and approval and requires a new review/build.

**Done condition:** only exact human, approved, rights-cleared, hash-bound,
technically conforming, device-verified audio ships. Normal builds exclude all
current synthetic/TTS/Suno files and hide Listen until then. The lifecycle
remains `verification_pending`.
