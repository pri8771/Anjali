# TF-001.2 Review Baseline Preflight

**Status:** `verification_pending` — packet preparation only; no human
cultural/theological review or provenance approval has occurred.

## Baseline identity

- Git `HEAD`: `93e9826f43a08dd31dbb42fbcd8c2620e635e309`
- Working-tree caveat: the working tree was not clean at capture time,
  including `Anjali/Anjali/Resources/prayers.json` and generated `Content/`
  files. Therefore the HEAD commit is **not** a clean review freeze; the
  following hashes identify the exact supplied files.
- `Anjali/Anjali/Resources/prayers.json` SHA-256:
  `f29928e0bf5cbf7622daa711dad52bd42c02d9b69331057ef47b5f529af8ced7`
- `Content/prayer_catalog_seed.csv` SHA-256:
  `7abb7f3818526d6e7113d3ee8b351b72d34de950441a456b2b3c4580fbc0dc4b`
- Record count: 22
- Reviewer packet: `Content/tf-001-review-packet.md`

## Commands and results

| Command | Result |
|---|---|
| `python3 Scripts/validate_prayers.py` | exit 0 — structural validation passed, 22 prayers valid; 0/22 named-reviewer sign-offs |
| `python3 Scripts/validate_prayers.py --require-signoff` | exit 1 — **expected** release-gate failure, 22 unsigned records (0/22); no approval was inferred or added |
| `python3 Scripts/export_catalog.py` | exit 0 — exported 22 prayers to `Content/prayer_catalog_seed.csv` |
| `shasum -a 256 Anjali/Anjali/Resources/prayers.json Content/prayer_catalog_seed.csv` | exit 0 — hashes recorded above |

## Expected sign-off block

The sign-off gate remains intentionally red: **0/22** records have a named
human reviewer and ISO review date. TF-001 cannot advance until a qualified
human reviews every row, records explicit dispositions, and approves the
resulting exact content commit. This preflight does not constitute, substitute
for, or authorize that review.
