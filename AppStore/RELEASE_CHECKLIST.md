# Anjali Distribution Checklist

The canonical TestFlight backlog is
`../docs/TESTFLIGHT_READINESS_BACKLOG.md`. This file is a compact operator view.
Do not mark a row complete without that task's repository evidence.

## A. External TestFlight

### Content and public information

- [ ] **TF-001:** 22/22 prayers have named human sign-off; both validators pass.
- [x] Provisional audio is absent from target membership and the catalog.
- [ ] **TF-003:** public privacy URL is live and beta feedback email tested.
- [ ] **TF-004:** `testflight_metadata.md` has no placeholders and matches the
      product.

### Apple identity and release candidate

- [ ] **TF-002:** agreements, team, App ID, bundle ID, app record, name, SKU,
      access, rights, and initial region decision confirmed.
- [ ] **TF-005:** version/build and exact Git SHA frozen; build number confirmed
      unused in App Store Connect.
- [ ] **TF-006:** exact-commit content/build/test/responsive/CI/archive gate
      passes.
- [ ] **TF-007:** human accessibility and real-device QA is signed.

### Distribution

- [ ] **TF-008:** signed App Store archive and Organizer validation pass.
- [ ] **TF-009:** upload completes, processing/compliance clears, and the build
      is TestFlight-eligible.
- [ ] **TF-010:** internal group installs the processed build on real iPhone and
      iPad; go decision recorded.
- [ ] **TF-011:** external group and Test Information are complete; Beta App
      Review approves the build.
- [ ] **TF-012:** controlled external cohort is triaged with no open P0 or
      release-blocking P1.

## B. App Store submission follow-on

These are not all prerequisites for the first internal TestFlight install.
Complete them before App Store version submission or sooner if App Store
Connect blocks a required beta action.

- [ ] **AS-001:** complete the current age-rating questionnaire. Treat 4+ as an
      expected outcome, not an answer to force.
- [ ] **AS-002:** confirm categories; proposed Lifestyle primary and Health &
      Fitness secondary.
- [ ] **AS-003:** complete App Privacy (“Data Not Collected” only while the
      binary still matches) and live support URL.
- [ ] **AS-004:** capture current required iPhone/iPad screenshots.
- [ ] **AS-005:** enter approved store copy, keywords, promotional text, and
      What's New; do not advertise audio in text-only v1.
- [ ] **AS-006:** complete content rights, DSA/trader status, price,
      availability, and region-specific compliance. Do not enable China
      mainland without legal/account-owner review of permit fields relevant to
      religious information.
- [ ] **AS-007:** select the final build, complete App Review contact/notes, and
      submit the App Store version.

## Quick repository gates

```bash
python3 Scripts/validate_prayers.py
python3 Scripts/validate_prayers.py --require-signoff
python3 Scripts/export_catalog.py
git diff --exit-code -- Content/
./Scripts/build.sh
```

Use the destination matrix and archive commands in `../docs/TEST_PLAN.md`.
Build/test evidence belongs under `../quality/evidence/` and `../BuildReports/`.
