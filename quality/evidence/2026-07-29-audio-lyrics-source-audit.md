# Audio, lyrics, and source audit — 2026-07-29

Status: **verification pending**. This is forensic evidence, not cultural,
pronunciation, legal, or release approval.

The row-level source of truth is
[`Content/audio_candidate_manifest.csv`](../../Content/audio_candidate_manifest.csv).
It inventories all 22 prayer IDs, including the 20 repository assets and the two
IDs with no prayer-specific asset.

## Conclusion

The current audio set must not ship.

- Eleven files are synthetic macOS `Lekha` TTS generated from the correct
  Devanagari input, but each full prayer was repeated between three and seven
  times while the player displays one copy. This proves a structural
  text-to-audio mismatch even before pronunciation is considered.
- Nine MP3 files are byte-identical to Digital Temple Suno
  `traditional_religious` variants. Their names and catalog topics correspond
  to the selected prayers, but eight have no audited heard transcript and
  therefore remain lyrically **unverifiable**. `shanti-asato-ma` has a
  source-catalog variant mismatch described below.
- The two Debug substitutions are provably different prayers and must be
  removed. Missing audio must use the timed-text behavior.
- No asset has the evidence required by
  [`Content/audio_spec.md`](../../Content/audio_spec.md): named pronunciation
  reviewer and approval, verified heard transcript, rights clearance,
  line timing, loudness/true-peak report, trim report, and real-device
  text/audio QA.
- Every shipping `audioAssetName` is currently `null`. That Release/TestFlight
  exclusion is correct and must remain until a candidate clears all gates.

## Method

The audit used local, non-mutating inspection only. No source audio was copied,
moved, renamed, converted, or edited.

1. Enumerated `Anjali/Anjali/Resources/Audio` and measured each file with
   `afinfo`.
2. Calculated SHA-256 with `shasum -a 256`.
3. Compared prayer IDs, displayed Devanagari, durations, contexts, and
   `audioAssetName` values against
   `Anjali/Anjali/Resources/prayers.json`.
4. Inspected embedded strings and metadata. The Suno files expose a
   “made with suno” comment and generation identifier but no full lyrics. The
   TTS files expose no embedded lyric transcript.
5. Recovered the July 1 TTS generator from the local Claude session record:
   `/Users/pchordia/.claude/projects/-Users-pchordia-Documents-Github-Anjali/8a2ca7a0-acf3-4ea5-a2c0-9d0fe2c1a2e3.jsonl`.
   It passed each prayer's Devanagari to `say -v Lekha -r 95`, inserted 900ms
   gaps, repeated the full string to fill the target time, and converted to
   AAC/m4a. A Git comparison confirmed the current primary text and
   transliteration are unchanged from the audio-import commit.
6. Compared the nine MP3 hashes with:
   `/Users/pchordia/Documents/wip_apps/core_apps/digital_temple/digital_temple/digital_temple/Resources/AudioCatalog/suno_audio_catalog_v1.with_assets.json`.
   Each hash resolves to the exact named Digital Temple variant listed in the
   manifest.
7. Inspected `PlayerController.debugPreviewAudioFallback(for:)` and confirmed
   the two deterministic cross-prayer substitutions.
8. Searched Digital Temple and Svara catalogs for alternatives. Results are
   discovery candidates only; a deity, title, theme, or filename match was
   never treated as proof of matching lyrics.

No automatic speech recognition or human listening transcript was used.
Consequently, filenames, catalog prose, and hashes establish file identity and
declared association, not the exact words actually heard.

## Twenty repository assets

| Prayer ID | File evidence | Lyric finding | Required disposition |
| --- | --- | --- | --- |
| `ganesha-gam` | Suno MP3, 34.920s, 48 kHz stereo | Digital Temple hash/title match; heard words and repetition are unverified. Current 35s catalog duration was changed from the 12s hero target to fit the song. | Quarantine. |
| `ganesha-shri` | Lekha TTS m4a, 9.653s, 44.1 kHz stereo | Exact current input, repeated 4×; pronunciation unverified. | Internal fixture only. |
| `ganesha-vakratunda` | Suno MP3, 18.960s, 48 kHz stereo | Digital Temple hash/title match; heard transcript unverified. | Quarantine. |
| `shiva-namah` | Suno MP3, 179.592s, 48 kHz stereo | Digital Temple hash/title match only; full song exceeds the 60s limit and replaces the intended 15s micro-prayer. | Quarantine. |
| `shiva-mahamrityunjaya` | Lekha TTS m4a, 40.930s, 44.1 kHz stereo | Exact current two-line input, repeated 5×; pronunciation unverified. | Internal fixture only. |
| `vishnu-narayana` | Suno MP3, 112.752s, 48 kHz stereo | Digital Temple hash/title match only; full song exceeds the 60s limit and replaces the intended 20s micro-prayer. | Quarantine. |
| `krishna-vasudeva` | Suno MP3, 88.464s, 48 kHz stereo | Digital Temple hash/title match only; full song exceeds the 60s limit and replaces the intended 20s micro-prayer. | Quarantine. |
| `krishna-mahamantra` | Suno MP3, 22.152s, 48 kHz stereo | Digital Temple hash/title match; order, repetition, and pronunciation unverified. | Quarantine. |
| `hanuman-namah` | Lekha TTS m4a, 15.085s, 44.1 kHz stereo | Exact current input, repeated 7×; pronunciation unverified. | Internal fixture only; never use for Manojavam. |
| `saraswati-aim` | Lekha TTS m4a, 14.633s, 44.1 kHz stereo | Exact current input, repeated 6×; pronunciation unverified. | Internal fixture only. |
| `lakshmi-shrim` | Lekha TTS m4a, 16.108s, 44.1 kHz stereo | Exact current input, repeated 6×; pronunciation unverified. | Internal fixture only. |
| `devi-dum` | Lekha TTS m4a, 15.712s, 44.1 kHz stereo | Exact current input, repeated 7×; pronunciation unverified. | Internal fixture only. |
| `devi-navarna` | Lekha TTS m4a, 20.729s, 44.1 kHz stereo | Exact current input, repeated 7×; pronunciation and lineage-sensitive form unverified. | Internal fixture only. |
| `surya-gayatri` | Suno MP3, 27.984s, 48 kHz stereo | Digital Temple hash/title match; Vedic words, accents, repetition, and pronunciation unverified. | Quarantine. |
| `surya-namah` | Lekha TTS m4a, 12.624s, 44.1 kHz stereo | Exact current input, repeated 6×; pronunciation unverified. | Internal fixture only. |
| `shanti-triple` | Lekha TTS m4a, 20.797s, 44.1 kHz stereo | The already-triple phrase is repeated 7×; pronunciation unverified. | Internal fixture only. |
| `shanti-asato-ma` | Suno MP3, 25.680s, 48 kHz stereo | Hash-linked source catalog includes an opening Oṃ and closing triple-Śānti absent from Anjali. Direct heard transcript remains open. | Quarantine as partial mismatch. |
| `shanti-sarve-bhavantu` | Suno MP3, 21.504s, 48 kHz stereo | Digital Temple hash/title match; ending, repetition, and pronunciation unverified. | Quarantine. |
| `shanti-lokah-samastah` | Lekha TTS m4a, 13.642s, 44.1 kHz stereo | Exact current input, repeated 4×; pronunciation unverified. | Internal fixture only. |
| `shanti-saha-navavatu` | Lekha TTS m4a, 25.993s, 44.1 kHz stereo | Exact current text, without the common triple-Śānti closing, repeated 3×; pronunciation and editorial omission unapproved. | Internal fixture only. |

The eleven m4a files satisfy only the container/codec/sample-rate/channel shape
of the recording specification. Synthetic speech fails the human-recitation
rule, and no loudness, true-peak, or trim evidence exists. The nine Suno files
are MP3 at 48 kHz, contain generated musical production, lack technical
mastering evidence, and fail the clean unaccompanied AAC/m4a requirement.

## Two provably wrong Debug fallbacks

The requested prayer ID is tried first. Since neither missing file exists, the
fallback is deterministic:

| Displayed prayer | Debug audio | Why it is wrong |
| --- | --- | --- |
| `vishnu-shantakaram` | `vishnu-narayana.mp3` | The UI displays the two-line “Śāntākāraṃ bhujagaśayanam” dhyāna śloka for a 30s sleep/sunset context while the audio candidate is the different “Oṃ Namo Nārāyaṇāya” mantra lasting 112.752s. |
| `hanuman-manojavam` | `hanuman-namah.m4a` | The UI displays the two-line “Manojavaṃ mārutatulyavegam” dhyāna śloka for 30s while the audio says the different “Oṃ Hanumate Namaḥ” input, repeated seven times over 15.085s. |

These are different prayers, not alternate recitations. Contextual similarity
or a shared deity cannot justify substitution.

## Asato Mā source-text mismatch

Anjali displays:

> असतो मा सद्गमय।  
> तमसो मा ज्योतिर्गमय।  
> मृत्योर्मा अमृतं गमय॥

The Digital Temple record for `suno_asato_ma_sadgamaya` in:

`/Users/pchordia/Documents/wip_apps/core_apps/digital_temple/digital_temple/digital_temple/Resources/AudioCatalog/devotional_audio_catalog_v1.json`

associates the variant with:

> ॐ असतो मा सद्गमय ।  
> तमसो मा ज्योतिर्गमय ।  
> मृत्योर्मा अमृतं गमय ।  
> ॐ शान्तिः शान्तिः शान्तिः ॥

The same catalog identifies the `traditional` asset with SHA-256
`c2132b7409dd8e4cd7a70b0d572fb6c329557cc32dbd96ca226961c719349fdf`.
Anjali's `shanti-asato-ma.mp3` has that exact hash, proving it is the cataloged
variant.

This proves a **catalog/source-text mismatch**: the intended source variant has
an opening Oṃ and closing triple-Śānti that the Anjali screen omits. It does not
replace a direct heard transcript of the MP3. The QA tracker still says
`needs_review` with no reviewer/date, and the source remains
`needs_owner_review`.

## Digital Temple and Svara discovery caveats

### Digital Temple

- The nine Anjali MP3s are byte-identical to the Digital Temple
  `traditional_religious` variants recorded in the manifest.
- `traditional` is a mix/style label. It does not mean human-recorded,
  pronunciation-reviewed, culturally approved, public-domain, or licensed.
- Digital Temple's rights inventory explicitly says it does not assert legal
  approval and that `needs_owner_review` requires human sign-off.
- The catalog intentionally omits full lyrics in some Suno metadata and warns
  against publishing until composition/source rights are checked.
- A separate candidate exists at
  `/Users/pchordia/Documents/wip_apps/core_apps/digital_temple/digital_temple/digital_temple/Resources/Audio/suno_maha_mrityunjaya_mantra_traditional.mp3`
  (27.504s, SHA-256
  `55b119e9fcce771edd00c0e78bafb90615ee24fd34d12be76190efabd3d30ef9`).
  The catalog text corresponds to the full Anjali verse, but the asset remains
  Suno-generated, instrumented, rights-unapproved, pronunciation-unreviewed,
  and contextually tagged for evening/night rather than Anjali's dawn/morning.
  It is a research candidate, not a Release asset.

### Svara

- Svara commit `09a603bbee3d97c44f749a2c1110dff80592d878`
  describes copying tracks from Digital Temple by “deity/theme,” which is not a
  lyric-verification method.
- Svara's `docs/AUDIO_PROVENANCE.md` leaves source/creator, consent, and license
  pending and requires human review for every listed file.
- `mantra_lakshmi.mp3` is a Digital Temple “Jai Maa Lakshmi” Hindi devotional
  song, not Anjali's `ॐ श्रीं महालक्ष्म्यै नमः`.
- `mantra_saraswati.mp3` is a Digital Temple “Jai Maa Saraswati” Hindi
  devotional song, not Anjali's `ॐ ऐं सरस्वत्यै नमः`.
- Those are false thematic matches and must not be copied into Anjali.

The broader search found no exact standalone candidate for 12 of the 22
Anjali prayers. Absence is preferable to a same-deity or same-theme
substitution.

## Evidence still required per candidate

Before setting any `audioAssetName` or including a file in Release:

1. Record a verbatim heard transcript, including invocations, repetitions,
   endings, omissions, and any non-lexical vocal material.
2. Compare it line by line with the human-approved Devanagari and IAST.
3. Obtain named qualified pronunciation/cultural review and date.
4. Record creator, recording source, consent, license, and owner approval.
5. Confirm deity, moment, time-of-day, intention, and repetition suitability;
   a filename or catalog tag is insufficient.
6. Produce a prayer-specific AAC/m4a, 44.1 kHz stereo, clean human recitation
   lasting 10–60s with no background music.
7. Attach measured −16 LUFS integrated, ≤−1 dBTP, and <0.3s leading/trailing
   silence evidence.
8. Add validated, ordered, non-overlapping per-line timing JSON if the product
   promises lyric synchronization.
9. Test the exact asset/text pair on a real device and have the reviewer sign
   the manifest row.

Until then, Debug may use clearly identified internal fixtures only. Release
must remain text-only.
