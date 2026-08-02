# TF-006 Release Automation Implementation Evidence — 2026-07-29

## Result

Repository-fixable release automation is implemented. The repository now has a
single exact-commit harness for Release compilation, Debug automated tests,
responsive UI coverage, unsigned archive construction, and bundle inspection,
plus an on-demand/tag GitHub Actions gate that runs blocking content checks
before allocating a macOS runner.

This is implementation evidence, not proof that the workflow ran remotely and
not an automated GO for a release candidate. TF-006 remains blocked until
TF-001 named-human content sign-off passes and the workflow is green on the
frozen TF-005 SHA.

## Changed surfaces

- `Scripts/release_gate.sh`
- `.github/workflows/release-gate.yml`
- `docs/TEST_PLAN.md`
- `docs/testflight-tasks/TF-006.md`

The regular `.github/workflows/ci.yml` push/pull-request semantics were not
changed.

## Implemented behavior

### Exact candidate and reproducible environment

- Requires a clean checkout and optionally verifies `EXPECTED_SHA` against
  `git rev-parse HEAD`.
- Records commit SHA, UTC timestamps, macOS, architecture, Xcode version,
  installed runtimes, Xcode destinations, and raw `simctl` device JSON.
- Manual workflow dispatch accepts only an exact 40-character `candidate_sha`;
  an omitted input and `v*` tags use the triggering commit SHA.

### Content/factory gates

- Runs structural prayer validation and the named-human sign-off validator as
  distinct, preserved logs.
- Parses project context, standard lock, and quality manifest JSON.
- Asserts the registered App Factory standard remains `0.2.0`.
- Regenerates the content export and rejects an out-of-sync candidate.
- Orders the workflow so failed sign-off blocks the expensive macOS job.

### Release and responsive test matrix

- Selects the newest installed iOS runtime from `simctl` JSON.
- Dynamically chooses distinct compact and large available iPhones and an
  available iPad; it fails clearly if the minimum matrix is unavailable.
- Performs one clean Release build and exactly one full Debug unit/UI run on
  the large iPhone.
- Performs UI-only Debug runs on the compact iPhone and iPad.
- Keeps deterministic reset/seed launch hooks behind `#if DEBUG`; it does not
  define `DEBUG` or enable those fixtures in the production Release build.
- Establishes Release fidelity separately with the clean build and ordinary
  unsigned Release archive.
- Preserves destination-specific logs, `.xcresult` bundles, and
  `xcresulttool` JSON summaries with test/pass/failure/skip counts.

### Unsigned archive and inspection

- Creates a generic arm64 Release archive with
  `CODE_SIGNING_ALLOWED=NO`, explicitly as engineering evidence.
- Compares archived bundle ID, marketing version, build number, and deployment
  target to Release build settings.
- Asserts iPhone/iPad families and non-exempt encryption `false`.
- Requires the compiled icon, privacy manifest, and prayer catalog.
- Requires a nonempty catalog with every `audioAssetName` null and zero bundled
  `.mp3`, `.m4a`, `.wav`, `.caf`, or `.aac` files.
- Confirms an arm64 executable and rejects non-system dynamic dependencies.
- Writes a compact summary only after every command and assertion succeeds.

## Local implementation validation

The following non-release checks were run while implementing:

```bash
bash -n Scripts/release_gate.sh
ruby -e 'require "yaml"; YAML.load_file(".github/workflows/release-gate.yml")'
python3 -m json.tool .factory/project-context.json
python3 -m json.tool .factory/standard-lock.json
python3 -m json.tool quality/quality-manifest.json
python3 Scripts/validate_prayers.py
git diff --check
```

| Validation | Result |
|---|---|
| `bash -n Scripts/release_gate.sh` | Pass |
| `actionlint .github/workflows/release-gate.yml` | Pass |
| Ruby YAML parse | Pass |
| Factory/quality JSON parsing | Pass |
| Structural prayer validation | Pass — 22 valid; 0/22 human sign-offs recorded |
| Scoped `git diff --check` | Pass |

The full new harness was not run from the current dirty shared working tree
because it correctly refuses non-frozen candidates. The current baseline
evidence is
`quality/evidence/2026-07-29-current-engineering-preflight.md`; it records a
green large-iPhone baseline, 4/4 Debug UI passes on both compact iPhone and
iPad, and successful unsigned archive inspection. Those results are still
dirty-tree evidence; the new automation must execute the whole matrix on the
eventual clean TF-005 SHA.

## Required completion handoff

1. Complete TF-001 human review; never infer reviewer identity or approval.
2. Freeze TF-005 and record its exact commit SHA.
3. Dispatch `Release readiness gate` with that full SHA.
4. Confirm both jobs and downloaded artifacts name the same checked-out SHA.
5. Preserve workflow URL/run ID and artifact references in the final
   `quality/evidence/YYYY-MM-DD-tf-006-automated-gate.md`.
6. Mark missing, canceled, or skipped matrix rows `Not run`; do not reuse this
   implementation evidence as a candidate pass.
