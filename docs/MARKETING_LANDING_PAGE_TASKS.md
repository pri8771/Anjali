# Anjali landing page, icon, and waitlist tasks

Status: `planned`  
Created: 2026-08-03  
Public route: `https://priyanshchordia.com/products/anjali/`

## Outcome

Publish an honest, accessible Anjali marketing page with a selected new icon
direction, exact-candidate screenshots, and an app-specific HubSpot waitlist.
This track does not waive the TestFlight, cultural-review, audio, privacy, or
device gates in `TESTFLIGHT_READINESS_BACKLOG.md`.

The local Claude Design reference package is
`/Users/pchordia/Documents/claude-design-handoff-five-apps-2026-08-03.zip`.
It is a coordination artifact, not repository evidence and not an approved
design. Claude Design is requested to create three complete Anjali concepts as
part of 15 total portfolio concepts.

## Product truth

- Positioning: **A sacred pause, not a session.**
- Market the current offline Hindu micro-prayer product only.
- Do not imply approved recorded audio unless it exists in the exact captured
  candidate.
- Do not use unreviewed sacred text or symbols as decorative material.
- Do not claim cultural/theological approval while the named review gate is open.
- Do not imply App Store availability before a verified public listing exists.

## Asset baseline

- Current opaque 1024×1024 icon exists and is supplied as a reference.
- No approved website screenshot set is supplied.
- Claude Design must use labeled placeholders and return an exact capture list.
- New icon concepts are candidates only; selecting one does not authorize an
  application-icon change or a new binary.

## Task index

| ID | Task | Status | Depends on | Completion evidence |
|---|---|---|---|---|
| ANJ-LP-001 | Reconcile public claims with the exact TestFlight candidate | ready | candidate identity | Reviewed claim matrix with build/SHA |
| ANJ-LP-002 | Run the Claude Design package intake and produce 3 full concepts plus 3 icon candidates | ready | handoff ZIP | 3 clickable concepts, ingestion report, diversity matrix |
| ANJ-LP-003 | Review concepts for product clarity, cultural respect, accessibility, and static-site feasibility | blocked | ANJ-LP-002, named human reviewers | Recorded dispositions and one selected direction |
| ANJ-LP-004 | Capture approved real screenshots | blocked | selected direction, exact candidate, content approval | Shot manifest, checksums, device/build provenance |
| ANJ-LP-005 | Finalize landing-page copy and limitations | blocked | ANJ-LP-001, cultural review | Approved copy deck with unsupported claims removed |
| ANJ-LP-006 | Select and production-test an icon candidate | blocked | ANJ-LP-003 | Small-size, contrast, opacity, uniqueness, and owner approval evidence |
| ANJ-LP-007 | Approve website privacy and app-specific waitlist consent | blocked | controller/contact and HubSpot configuration | Approved disclosure, retention/deletion path, consent text |
| ANJ-LP-008 | Hand selected assets and copy to the canonical website repository | blocked | ANJ-LP-004 through ANJ-LP-007 | Versioned handoff manifest; no private fields |
| ANJ-LP-009 | Verify implemented page and waitlist | blocked | website implementation | Mobile/desktop/a11y/form/privacy/link evidence |
| ANJ-LP-010 | Approve publication | blocked | ANJ-LP-009 | Exact website commit and owner approval |

## Screenshot minimum

Capture Today, an accurate self-led Chant or Silent state, Find, saved/reminder
state, and completion. Use only approved prayer content. Record device, OS,
build, source SHA, appearance, and whether the screenshot is website-only or
also App Store-eligible.

## Waitlist contract

Required public field: email. Optional fields: first name and device/testing
interest. Require app-specific consent. Hidden context may include
`app_slug=anjali`, page path, source, and UTM values. Do not subscribe a contact
to other apps without separate consent. Prototype and verify validation,
submitting, success, duplicate, service-error, and email-fallback states.

## Done means

The page is not done when a prototype exists. It is done only when the selected
design uses real approved assets and copy, the HubSpot path and portfolio
privacy disclosure are verified, accessibility and responsive checks pass, the
exact deployment is recorded, and the owner explicitly approves publication.

## Website implementation update — 2026-08-03

The canonical website now implements all three Anjali directions—Six Lights,
Under a Minute, and Threshold—with a persistent/query-addressable selector,
responsive layouts, and CSS-rendered icon-direction previews. Automated site
checks and desktop/mobile selector checks pass. This does not complete
ANJ-LP-003 through ANJ-LP-010: cultural/claim review, real candidate screenshots,
production icon approval, HubSpot consent/form states, deployment evidence, and
publication approval remain open. The current CTA discloses an email fallback.
