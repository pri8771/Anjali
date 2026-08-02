# TF-001 model research A — evidence-only pre-review

**Scope:** `ganesha-gam` through `hanuman-manojavam` (11 assigned records),
read from the current canonical JSON on 2026-07-29. This is research support,
not a review disposition or approval.

## Shared finding

The current `isReviewed: true` values and blank provenance reviewer/date do
**not** constitute named human sign-off. No flag, packet checkbox, provenance,
or canonical prayer field was changed by this research. Moment, intention,
time, rotation, duration suitability, and pastoral tone are editorial/product
classifications; traditional witnesses ordinarily do not prescribe them, so a
qualified human reviewer must make those decisions.

Sources below are text witnesses, not a substitute for a sampradāya-aware
reviewer: [Sanskrit Documents—common shlokas](https://sanskritdocuments.org/doc_z_misc_general/shloka1.html),
[Sanskrit Documents—Viṣṇu pūjā stotra](https://sanskritdocuments.org/doc_vishhnu/viShNupUjAstotram.html),
[Sanskrit Documents—Kali-Santaraṇa Upaniṣad](https://sanskritdocuments.org/doc_upanishhat/kalisantarana_upan.html),
[VedSearch—Ṛgveda 7.59.12](https://vedsearch.org/rigved/7/59/12),
[Sanskrit Documents—Sundarakāṇḍa prayer verses](https://sanskritdocuments.org/doc_hanumaana/sundarakANDaprArthanAshlokAH.html),
and [Bhāgavata 1.1.1 text](https://vanisource.org/wiki/SB_1.1.1).

## Per-record findings

### `ganesha-gam` — needs human judgment (confidence: medium)

`ॐ गं गणपतये नमः` / `Oṃ Gaṃ Gaṇapataye Namaḥ` is internally consistent IAST
for the received bīja formula. “Ganapati bija mantra (traditional)” is a
properly modest attribution; I did not locate a single primary canonical verse
that should replace it. The literal sense is salutations to Gaṇapati; “remover
of obstacles” and “clear the way” are devotional framing rather than the
formula's literal wording. Exact conservative meaning candidate: **“Salutations
to Gaṇapati.”** The listed deity is directly apt; all classifications and the
`dailyAnchor` choice require human editorial judgment. Cite: [common Ganeśa
recitation context](https://sanskritdocuments.org/doc_z_misc_general/shloka1.html).

### `ganesha-shri` — correction candidate (confidence: high)

Devanagari and IAST are consistent: `ॐ श्री गणेशाय नमः` / `Oṃ Śrī Gaṇeśāya
Namaḥ`. “Traditional Ganesha namaḥ mantra” is appropriately non-specific.
The current meaning adds “before stepping out into the day,” which is not
textual. Suggested exact meaning: **“Salutations to auspicious Ganesha.”**
Deity fits; contexts, intention labels, and rotation remain human editorial
judgment. Cite: [Ganeśa liturgical collection](https://sanskritdocuments.org/doc_z_misc_general/shloka1.html).

### `ganesha-vakratunda` — needs human judgment (confidence: medium)

The app's `सूर्यकोटि समप्रभ` is a recognized recitational form, while the
Sanskrit Documents witness reads `कोटिसूर्यसमप्रभ`; this is a variant, not
enough evidence to silently normalize canonical text. IAST and the translation
are sound for the displayed form. The witness supports the verse but not a
precise Purāṇic provenance. Suggested exact source-title candidate: **“Ganesha
dhyāna śloka (traditional)”** (remove “Puranic” unless the reviewer supplies a
verified source). Deity and work/study classifications are plausible but need
human judgment. Cite: [variant witness](https://sanskritdocuments.org/doc_z_misc_general/shloka1.html).

### `shiva-namah` — correction candidate (confidence: high)

`ॐ नमः शिवाय` / `Oṃ Namaḥ Śivāya` is textually standard in Śaiva practice.
However, with `Oṃ` it is conventionally six syllables; the five-syllable core
is `Namaḥ Śivāya`. The precise current Śrī Rudram attribution is over-specific
for the full displayed formula (Rudram includes `namaḥ śivāya ca`). Suggested
exact source title: **“Ṣaḍakṣara mantra (Śaiva tradition)”**. Suggested exact
source reference: **“Traditional Śaiva ṣaḍakṣara mantra; Pañcākṣarī core:
‘Namaḥ Śivāya’.”** The first sentence of the meaning is faithful; the
“surrender and stillness” sentence is interpretive. Also, `durationSeconds:
180` conflicts with the repository content guideline's stated 10–60-second
recitation range and needs product-owner/reviewer resolution. Contexts and
tone require human judgment. Cite: [Śaiva pūjā text using the formula](https://sanskritdocuments.org/doc_shiva/shivapuja.html),
[Pañcākṣarī/ṣaḍakṣara discussion](https://sanskritdocuments.org/doc_shiva/panchAkSharImAhAtmyam.html).

### `shiva-mahamrityunjaya` — supported (confidence: high)

The displayed text, including `मामृतात्` (sandhi for `मा अमृतात्`), IAST, and
core meaning agree with Ṛgveda 7.59.12. “Free us from death—not from
immortality” preserves the negation. The Vedic addressee is Tryambaka/Rudra;
identification as Śiva is established Śaiva reception, so the deity label and
all classifications should still be human-confirmed rather than treated as a
textual fact. Cite: [Ṛgveda 7.59.12 Sanskrit witness](https://vedsearch.org/rigved/7/59/12),
[plain/transliterated text and translation](https://www.wisdomlib.org/hinduism/book/rig-veda-english-translation/d/doc835080.html).

### `vishnu-narayana` — correction candidate (confidence: high)

`ॐ नमो नारायणाय` / `Oṃ Namo Nārāyaṇāya` is correct; its eight-syllable
designation is conventional. “Refuge of all beings” and “mantra of trust” go
beyond the literal salutation. Suggested exact meaning: **“Salutations to
Nārāyaṇa.”** The traditional/Nārāyaṇa-Upaniṣad framing is supportable but a
reviewer should decide whether to cite a particular recension. Deity fits;
contexts, rotation, and tone require human judgment. Cite: [Nārāyaṇa text
collection](https://sanskritdocuments.org/narayana), [liturgical witness with
the formula](https://sanskritdocuments.org/doc_vishhnu/nArAyaNIyam.html).

### `vishnu-shantakaram` — supported (confidence: high)

The two displayed lines, IAST, and compressed meaning match the standard
Śāntākāram verse witness. They are a deliberate excerpt of a four-line verse;
the reviewer should confirm that excerpting is intended. “Traditional” is
safer than a claimed single canonical source. Deity is direct; sleep/sunset
classification and the `occasional` rotation are human editorial judgments.
Cite: [Viṣṇu pūjā stotra](https://sanskritdocuments.org/doc_vishhnu/viShNupUjAstotram.html),
[Nārāyaṇa stuti witness](https://sanskritdocuments.org/doc_vishhnu/nArAyaNastutiH.html).

### `krishna-vasudeva` — correction candidate (confidence: high)

Devanagari and IAST for `ॐ नमो भगवते वासुदेवाय` are correct, and the formula
opens Śrīmad Bhāgavata 1.1.1. “Vāsudeva (Krishna)” is a valid Bhāgavata
reading but may be narrower than other Vaiṣṇava understandings. Suggested
exact source reference: **“Śrīmad Bhāgavata 1.1.1: ‘Oṃ Namo Bhagavate
Vāsudevāya’.”** Suggested exact meaning: **“Salutations to Bhagavān
Vāsudeva.”** The `krishna` label and all contexts need human,
sampradāya-aware confirmation. Cite: [Bhāgavata 1.1.1](https://vanisource.org/wiki/SB_1.1.1).

### `krishna-mahamantra` — needs human judgment (confidence: high)

The app's Devanagari, IAST, and concise meaning are sound for the widespread
Kṛṣṇa-first recitation. The Kali-Santaraṇa Upaniṣad witness has the same
sixteen names but presents the Rāma line first. Therefore, it supports the
formula family but not an unqualified claim that its exact displayed ordering
is that Upaniṣad's wording. Suggested exact source-title candidate:
**“Mahāmantra (Vaiṣṇava tradition; Kali-Santaraṇa Upaniṣad preserves a
Rāma-first ordering)”**. A qualified reviewer should decide whether to retain
the current attribution, cite a Kṛṣṇa-first witness, or change ordering.
`deity=krishna` likewise needs a human decision because Rāma is explicitly
present. Cite: [Kali-Santaraṇa Upaniṣad](https://sanskritdocuments.org/doc_upanishhat/kalisantarana_upan.html).

### `hanuman-namah` — correction candidate (confidence: medium)

`ॐ हनुमते नमः` / `Oṃ Hanumate Namaḥ` is internally correct and appears in
devotional liturgical collections. “Traditional Hanuman namaḥ mantra” is
honest. “Fearless protector” and “for courage on the road” are devotional/
product framing beyond the literal text. Suggested exact meaning:
**“Salutations to Hanuman.”** Deity fits; travel/protection classifications,
rotation, and tone need human judgment. Cite: [Hanumān nāmāvalī](https://sanskritdocuments.org/doc_hanumaana/hanuman108.html).

### `hanuman-manojavam` — correction candidate (confidence: high)

The app's `शरणं प्रपद्ये` ending is an attested variant; the cited prayer-text
source prints `शिरसा नमामि` and explicitly notes `(शरणं प्रपद्ये)`. IAST and
meaning accurately follow the app's variant. “Sundarakāṇḍa tradition” should
not be read as a precise Valmīki Rāmāyaṇa verse citation. Suggested exact
source title: **“Traditional Hanuman prayer śloka (used in Sundarakāṇḍa
recitation)”**; make the same wording change in `sourceReference`. Deity fits;
travel/anxiety contexts and tone need human judgment. Cite: [variant witness](https://sanskritdocuments.org/doc_hanumaana/sundarakANDaprArthanAshlokAH.html),
[word-by-word meaning collection](https://sanskritdocuments.org/doc_z_misc_general/allshlokawmean.pdf).

## Non-signoff disclaimer

This memo is generated research only. It does **not** approve, reject, or
clear any prayer; it does **not** represent a Hindu cultural/theological
review; and it must not be used to set `isReviewed`, `needsReview`, reviewer
names/dates, or provenance. TF-001 remains blocked pending explicit named
human, record-by-record review and sign-off.
