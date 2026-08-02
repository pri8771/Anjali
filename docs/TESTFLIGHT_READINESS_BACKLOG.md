# TestFlight Readiness Backlog

Canonical as of 30 July 2026.

This file is the repository source of truth for getting Anjali into internal
and external TestFlight. Jira and Notion, if used, must copy these task IDs,
descriptions, acceptance criteria, dependencies, and statuses. Resolve a
conflict in favor of this file, then update the copies.

Detailed implementation plans live in `docs/testflight-tasks/`. The backlog
owns order/dependency/status; each task brief owns its subtask IDs, expected
changes, procedures, completion tests, evidence, and escalation boundaries.
Read the complete task brief before executing a task.

## Outcome and current verdict

The target outcome is:

> A signed Anjali 1.0 build, produced from an identified release commit, passes
> the repository gates, processes in App Store Connect, passes internal
> TestFlight device QA, passes TestFlight App Review, and is available to a
> controlled external tester group.

Current verdict: **not ready for consumer or external TestFlight**.

The changed working tree has 75/75 passing unit/integration tests, a passing
12/12 responsive UI matrix across large/compact iPhone and iPad (including Om
Namo Narayanaya), and a passed unsigned zero-audio Release build, but it is
dirty and not a candidate. Manual physical-device and accessibility matrices
remain pending.
Human prayer review is still 0/22. No acceptable human audio exists; normal
Debug, device, Release, and TestFlight builds contain no synthetic/provisional
audio and hide Listen. A clean exact-SHA remote gate, Apple account
configuration, public privacy/contact details, signed distribution,
real-device QA, and external Beta App Review also remain open.

Distribution mechanics in this backlog do not independently authorize a
consumer beta. The
[Daily-Use Consumer Product Plan](DAILY_USE_PRODUCT_PLAN.md) owns the
consumer-product gate; its P0 and named-human prerequisites block candidate
freeze.

Execution evidence is summarized in
`quality/evidence/2026-07-29-testflight-execution-status.md`; the App Factory
completion record is
`quality/completion-reports/TESTFLIGHT-EXECUTION-2026-07-29.json`.

## How to execute this backlog

### Status vocabulary

- `ready`: an implementer can start with the repository and named human input.
- `blocked`: a prerequisite or authorized human/account action is missing.
- `in_progress`: work has started and partial evidence is linked.
- `verification_pending`: implementation is complete but required independent
  evidence is not.
- `done`: every acceptance criterion and evidence item is present.

Do not use `done` to mean “code written,” “looks correct,” “requested from
someone,” or “works on a simulator.” App Factory completion rules still apply.

### Rules for lower-capability implementers

1. Read `AGENTS.md`, `.factory/AGENTS.factory.md`,
   `quality/quality-manifest.json`, this file, and the task's named inputs.
2. Work on one task ID at a time. Do not silently broaden its scope.
3. Record the exact commit, build number, device, OS, Xcode version, date, and
   person for evidence where the task requests them.
4. Never invent a reviewer, review date, Apple account state, URL, device pass,
   upload result, or App Store Connect status.
5. Never add networking, analytics, accounts, third-party SDKs, cloud
   notifications, or production fixtures to solve a release task.
6. Keep all provisional audio excluded. Shipping audio must remain zero until
   a separately reviewed human recording meets `Content/audio_spec.md`.
   Candidate discovery, exact-ID playback, transcript/timing review, and future
   enablement are governed by `docs/AUDIO_LYRIC_ALIGNMENT_PLAN.md`; a matching
   filename or sibling-project catalog row is not approval.
7. Preserve failures and screenshots/logs. A failed gate is evidence, not
   permission to weaken the gate.
8. Update this file first when status changes. Jira/Notion copies follow.
9. Read `docs/DAILY_USE_PRODUCT_PLAN.md` before candidate freeze. A green
   engineering or App Store Connect step does not override its consumer gate.

### Evidence location and naming

Commit durable evidence under `quality/evidence/`. Use:

```text
quality/evidence/YYYY-MM-DD-<task-id-lowercase>-<short-name>.md
quality/evidence/YYYY-MM-DD-<task-id-lowercase>-<artifact>.<ext>
```

Do not commit Apple credentials, API keys, provisioning private keys, tester
email lists, personal phone numbers, or unredacted account screenshots.
Reference restricted evidence by owner, date, and App Store Connect location.

## Dependency map

Tasks in the first three lanes can overlap until candidate freeze. Distribution
cannot.

```text
Content:  TF-001 ─┐
Identity: TF-002 ─┼─ TF-005 ─ TF-006 ─ TF-007 ─ TF-008 ─┐
                  │                                      ├─ TF-009 ─ TF-010 ─ TF-011 ─ TF-012
Metadata: TF-003 ─ TF-004 ───────────────────────────────┘
```

`TF-001` may overlap with account, metadata, and local preparatory work, but
content corrections and the Daily-Use P0 prerequisites must finish before
TF-005 freezes a consumer candidate.

## Task index

| ID | Task | Owner type | Status | Depends on | Blocks |
|---|---|---|---|---|---|
| TF-001 | [Complete named human prayer-content sign-off](testflight-tasks/TF-001.md) | Human content owner | blocked | reviewer appointment | external beta |
| TF-002 | [Establish Apple account, App ID, and app record](testflight-tasks/TF-002.md) | Account Holder/Admin | blocked | account access | signed upload |
| TF-003 | [Publish privacy URL and set beta contacts](testflight-tasks/TF-003.md) | Release/legal owner | blocked | public host and contacts | external beta |
| TF-004 | [Finalize the TestFlight metadata and review packet](testflight-tasks/TF-004.md) | Product/release owner | ready | TF-003 values | external review |
| TF-005 | [Freeze the release candidate and unique build identity](testflight-tasks/TF-005.md) | Engineering/release owner | blocked | TF-001, TF-002, Daily-Use consumer gate | archive/upload |
| TF-006 | [Run the exact-commit automated release gate](testflight-tasks/TF-006.md) | Engineering/CI | blocked (automation prepared; TF-005 SHA required) | TF-005 | device QA |
| TF-007 | [Complete manual accessibility and device QA](testflight-tasks/TF-007.md) | Human QA | blocked | real devices, TF-006 | external beta |
| TF-008 | [Create and inspect a signed distribution archive](testflight-tasks/TF-008.md) | Signing owner | blocked | TF-002, TF-005, TF-006, TF-007 | upload |
| TF-009 | [Upload, process, and clear compliance](testflight-tasks/TF-009.md) | App Store Connect operator | blocked | TF-004, TF-008 | TestFlight groups |
| TF-010 | [Run internal TestFlight and record a go/no-go](testflight-tasks/TF-010.md) | Internal QA | blocked | TF-009 | external review |
| TF-011 | [Submit and clear external Beta App Review](testflight-tasks/TF-011.md) | App Manager | blocked | TF-001, TF-003, TF-004, TF-010 | external testers |
| TF-012 | [Conduct controlled external beta and triage](testflight-tasks/TF-012.md) | Product/QA | blocked | TF-011 | App Store candidate |

---

## TF-001 — Complete named human prayer-content sign-off

**Status:** `blocked`  
**Owner:** product/content owner plus a named cultural/theological reviewer  
**May an autonomous model finish it?** No. A model may prepare the packet and
apply a named human's decisions, but may not supply the judgment or identity.  
**Current state:** structural validation passes 22/22; sign-off validation
correctly fails 0/22. The 22-record reviewer worksheet is prepared at
`Content/tf-001-review-packet.md`; model research has been consolidated as
reviewer cues only in
`quality/evidence/2026-07-29-tf-001-model-research-consolidation.md`.

### Purpose

Verify every bundled Sanskrit prayer, transliteration, English meaning, source,
deity/context classification, and tone before broad external distribution.
This is a repository product-safety gate even if Apple would technically allow
an internal build without it.

### Inputs

- `Anjali/Anjali/Resources/prayers.json`
- `Content/prayer_catalog_template.csv`
- `Content/content_review_checklist.md`
- `CONTENT_GUIDELINES.md`
- `Content/CONTENT_GUIDELINES.md`
- `Scripts/validate_prayers.py`

### Subtasks

1. Appoint a reviewer and record their agreed display name. Do not use a role
   such as “reviewer,” an organization alone, an AI system, or a placeholder.
2. Freeze a review copy of `prayers.json` and record its Git commit hash.
3. Export the catalog with `python3 Scripts/export_catalog.py`.
4. Review all 22 records one by one using the content checklist. The reviewer
   must explicitly inspect Sanskrit, transliteration, meaning, source claim,
   context/deity classification, and respectful presentation.
5. Resolve every correction in the canonical JSON first. Re-export CSVs after
   each accepted content batch.
6. For an approved record, set `isReviewed: true` and `needsReview: false`.
   For a rejected/unresolved record, set `isReviewed: false` and
   `needsReview: true`; do not continue to candidate freeze.
7. Only after the human approves a record, set its
   `provenance.reviewer` to the agreed named identity and
   `provenance.reviewedOn` to the real ISO `YYYY-MM-DD` review date.
8. Run both validators. Review the diff to ensure no unrelated content or audio
   reference changed.
9. Commit the approved JSON and generated catalog as a reviewed-content commit;
   record its full SHA.
10. From a clean checkout of that commit, run the exporter again and require no
    `Content/` diff.
11. Have the reviewer sign the evidence record referencing that reviewed-content
    SHA. Commit the evidence separately if needed.

### Verification

```bash
python3 Scripts/validate_prayers.py
python3 Scripts/validate_prayers.py --require-signoff
python3 Scripts/export_catalog.py
git diff --exit-code -- Content/
rg -n '"audioAssetName": "[^"]+"' Anjali/Anjali/Resources/prayers.json
rg -n '"isReviewed": false|"needsReview": true' \
  Anjali/Anjali/Resources/prayers.json
```

The final two `rg` commands must return no matches for this text-only,
fully-reviewed candidate.

### Acceptance criteria

- Both validators exit zero for the exact release-candidate content.
- All 22 records contain a real named reviewer and real review date.
- All 22 records have `isReviewed: true` and `needsReview: false`.
- Reviewer evidence identifies the reviewed commit and records 22/22 approval
  or lists resolved corrections.
- Exported catalog files match the canonical JSON.
- No provisional audio is reintroduced.

### Required evidence

Create `quality/evidence/YYYY-MM-DD-tf-001-content-signoff.md` containing the
reviewer name, review date, reviewed commit, record count, validator commands
and results, corrections made, and final reviewer approval.

### Failure/rollback

If any record is rejected, leave the task open, correct or remove that record,
and rerun the complete gate. Never bulk-fill provenance to make the validator
green.

---

## TF-002 — Establish Apple account, App ID, and app record

**Status:** `blocked`  
**Owner:** Apple Developer Account Holder or Admin; App Manager can perform
some App Store Connect steps  
**May an autonomous model finish it?** No. It requires authorized account
access and agreement/name/rights decisions.  
**Current repository values:** team `796XH483R4`, bundle ID
`app.anjali.Anjali`, app name `Anjali`, version `1.0`, current local build `1`.
Ownership and availability are unverified. Repository identity/capability
preflight is recorded in
`quality/evidence/2026-07-29-tf-002-apple-identity-preflight.md`.

### Purpose

Create the immutable Apple identity that a signed build will use. Apple
associates an upload using its bundle ID and version, and uniquely identifies
it with the build string.

### Subtasks

1. Account Holder confirms active Apple Developer Program membership and
   accepts the latest agreements.
2. Confirm team `796XH483R4` is the intended distribution team.
3. In Certificates, Identifiers & Profiles, confirm or register an explicit
   App ID whose bundle ID is exactly `app.anjali.Anjali`.
4. Confirm the App ID has no capabilities beyond what the shipping target
   needs. Local notifications do not require the Push Notifications capability.
5. In App Store Connect, confirm or create the iOS app record:
   - name: final approved name, initially `Anjali`;
   - primary language: product owner's choice;
   - bundle ID: `app.anjali.Anjali`;
   - SKU: stable internal value with no sensitive data;
   - user access: explicitly selected.
6. Search App Store Connect and the public store for name confusion. An
   accented `ANJĀLI` listing exists; the product/legal owner must approve the
   final name. Do not infer trademark clearance from App Store availability.
7. Confirm the team owns the bundled prayer content or has documented rights
   to use it. Complete App Store Connect Content Rights honestly when prompted.
8. Decide distribution regions. Because the product contains religious
   information, do not enable China mainland until the account/legal owner has
   reviewed Apple's region-specific permit fields and documented the decision.
9. Record the App Store Connect app Apple ID and authorized roles without
   storing credentials.

### Acceptance criteria

- Active agreements and membership are confirmed by the Account Holder.
- App ID and Xcode bundle ID match exactly.
- App Store Connect app record exists and is accessible to the release owner.
- Name, SKU, primary language, user access, content-rights owner, and initial
  region decision are recorded.
- No unexpected capability or entitlement is enabled.

### Required evidence

Create `quality/evidence/YYYY-MM-DD-tf-002-apple-identity.md` with non-secret
values, confirming owner/role/date, team ID, bundle ID, App Store Connect app
Apple ID, final name, SKU, region decision, and agreement status. Account
screenshots may remain in restricted storage; reference them without committing
personal information.

### Failure/rollback

Bundle ID and SKU choices become difficult or impossible to change after
upload. Stop before app-record creation if ownership, name, or bundle ID is
uncertain. Do not change repository identifiers merely to work around an
account-access failure.

---

## TF-003 — Publish privacy URL and set beta contacts

**Status:** `blocked`  
**Owner:** release/legal owner and public-site owner  
**May an autonomous model finish it?** Only after the owner supplies an
approved domain and contact values.  
**Current state:** repository policy/metadata claims have a source-backed
preflight; public URLs, owner approvals, and contact values remain `TBD`.

### Purpose

Give testers, Apple, and future store customers reachable privacy and support
contacts. Apple's TestFlight information requires a feedback email for external
testing; App Privacy requires a privacy-policy URL for all apps.

### Subtasks

1. Legal/product owner re-approves `AppStore/privacy_policy.md` and
   `AppStore/terms_of_service.md` against the actual build.
2. Publish the privacy policy at a stable public HTTPS URL that works without
   login, cookies, geoblocking, or a client app.
3. Choose a monitored beta feedback email. Confirm replies can be received.
4. Choose and publish a support URL. This is required for the later App Store
   version and strongly recommended before external beta, but it is not a
   substitute for TestFlight's required feedback email.
5. Confirm the policy's claims still match the shipping binary: no networking,
   account, analytics, tracking, third-party SDK, or collected data; local
   settings/reminders only.
6. Verify the URLs from a signed-out browser and a mobile device.
7. Replace URL/contact `TBD` fields in repository metadata files.

### Acceptance criteria

- Privacy URL returns HTTP 200 over HTTPS and is readable without sign-in.
- Feedback email is monitored and a reply test succeeds.
- Support URL is live or explicitly scheduled as an App Store follow-on with
  an owner/date.
- Public text and `PrivacyInfo.xcprivacy` agree with the exact build.
- Repository files contain the approved public values, not placeholders.

### Required evidence

Create `quality/evidence/YYYY-MM-DD-tf-003-public-contacts.md` with URLs,
verification date, verifier, response result, feedback-mailbox owner, and
privacy-claim comparison. Do not commit private mail headers.

---

## TF-004 — Finalize the TestFlight metadata and review packet

**Status:** `ready` for drafting; `blocked` for final values from TF-003  
**Owner:** product/release owner  
**Source template:** `AppStore/testflight_metadata.md`

The repository-resolvable copy audit is complete in
`quality/evidence/2026-07-29-tf-003-tf-004-metadata-preflight.md`; final
build/SHA, contacts, public URLs, and named approvals remain blocked.

### Purpose

Prepare the exact information Apple and testers will see. External TestFlight
requires additional Test Information and TestFlight App Review.

### Subtasks

1. Replace every bracketed placeholder in
   `AppStore/testflight_metadata.md`.
2. Verify Beta App Description describes only shipping behavior. It must say
   the beta is text-only; do not imply any audio is included.
3. Set the required Feedback Email from TF-003.
4. Complete review contact name, email, and phone using authorized human
   details. Keep private values in App Store Connect if repository publication
   is inappropriate.
5. Confirm “Sign-in required” is off. Anjali has no account and needs no demo
   credentials.
6. Finalize Review Notes explaining offline behavior, no account/data
   collection, local notification permission flow, no IAP, and text-only audio
   fallback.
7. Finalize a short, build-specific “What to Test” list. It must name the
   release build number after TF-005.
8. Have product/content, privacy, and QA owners review the copy for accuracy.
9. Enter the approved values in App Store Connect Test Information and the
   build/group fields. Keep the repo copy synchronized.

### Acceptance criteria

- No `TBD`, bracketed placeholder, false feature, or unsupported claim remains
  in the approved packet.
- Beta App Description, Feedback Email, Review Contact, Review Notes, and What
  to Test are complete.
- Accountless/offline navigation is sufficient for Apple to exercise the app.
- Text-only status and optional local-notification behavior are explicit.
- The repository and App Store Connect copies match.

### Verification

```bash
rg -n 'TBD|\\[[A-Z][A-Z0-9 _-]+\\]' AppStore/testflight_metadata.md
```

The command must return no matches after completion.

### Required evidence

Add the reviewer/date/build fields in `AppStore/testflight_metadata.md` and
reference the App Store Connect entry in the TF-009 evidence file.

---

## TF-005 — Freeze the release candidate and unique build identity

**Status:** `blocked` on TF-001/TF-002; otherwise ready after the product owner
confirms text-only scope  
**Owner:** engineering/release owner  
**Current values:** marketing version `1.0`; local build `1`.

### Purpose

Produce one traceable source commit and a build number that has never completed
an App Store Connect upload for this bundle/version.

### Subtasks

1. Confirm TF-001 and the candidate prerequisites in
   `docs/DAILY_USE_PRODUCT_PLAN.md` are complete so content or consumer-product
   corrections cannot invalidate the frozen candidate.
2. Confirm the beta scope: iOS 17+, iPhone/iPad, offline/accountless,
   self-led Chant and Silent, editable optional local reminders, no approved
   Listen audio, and no IAP.
3. Ensure the working tree contains only reviewed release changes. Do not
   discard unrelated user work.
4. Query App Store Connect build history for bundle `app.anjali.Anjali` and
   version `1.0`.
5. Select a monotonically higher unused `CURRENT_PROJECT_VERSION`. Do not guess
   from the local project alone.
6. Update both Debug and Release app-target build settings to the selected
   number. Do not change the test target unless Xcode requires alignment.
7. Keep `MARKETING_VERSION = 1.0` unless product explicitly changes the beta
   version.
8. Confirm all `audioAssetName` values are null and normal Debug, device,
   Release, and TestFlight builds contain no synthetic/provisional audio.
9. Commit the release candidate. Record its full Git SHA and prohibit source
   changes without a new candidate/build.
10. Add the build number to `AppStore/testflight_metadata.md`.

### Verification

```bash
git status --short
git rev-parse HEAD
rg -n 'MARKETING_VERSION|CURRENT_PROJECT_VERSION|PRODUCT_BUNDLE_IDENTIFIER' \
  Anjali/Anjali.xcodeproj/project.pbxproj
python3 Scripts/validate_prayers.py
```

### Acceptance criteria

- Source commit, version, build, bundle ID, and scope are recorded.
- The Daily-Use consumer gate explicitly authorizes candidate freeze.
- Build number is confirmed unused against App Store Connect, not assumed.
- Candidate contains zero synthetic/provisional audio assets/references and
  exposes no Listen affordance.
- Candidate is immutable; any source correction creates a new commit and build.

### Required evidence

Create `quality/evidence/YYYY-MM-DD-tf-005-release-candidate.md` with SHA,
branch/tag if any, version/build, App Store Connect uniqueness check, scope,
and approver.

---

## TF-006 — Run the exact-commit automated release gate

**Status:** `blocked` on TF-005  
**Owner:** engineering/CI  
**Inputs:** `docs/TEST_PLAN.md`, `Scripts/build.sh`,
`.github/workflows/ci.yml`, `.github/workflows/release-gate.yml`

### Purpose

Prove that the candidate—not a nearby working tree—passes factory, content,
build, unit/integration, UI, responsive, and archive-content checks.

### Subtasks

1. Check out the exact clean candidate commit.
2. Record macOS, Xcode, SDK, simulator runtime, and candidate SHA.
3. Run structural and named-signoff content gates.
4. Run `./Scripts/build.sh` on the current large iPhone.
5. Run the UI suite on the compact iPhone and iPad destinations documented in
   `docs/TEST_PLAN.md`.
6. Validate the local factory JSON, then rerun the registration verifier from
   an authorized checkout of the pinned
   `pri8771/iOS_app_factory_rules` 0.2.0 standard. This app repository does not
   vendor that verifier, so record the standard checkout SHA and exact command;
   do not invent a local script path or reuse an old “pass” after registration
   files change.
7. Produce an unsigned generic-device archive only as an engineering
   bundle-content check; do not confuse it with TF-008 signing validation.
8. Inspect the bundle for version/build, identifier, minimum OS, icon, privacy
   manifest, catalog, zero provisional audio, and system-only dependencies.
9. Confirm CI is green for the same SHA. Preserve logs and `.xcresult` bundles.

### Required commands

Use the commands in `docs/TEST_PLAN.md`; do not invent simulator names. The
minimum repository commands are:

```bash
python3 Scripts/validate_prayers.py
python3 Scripts/validate_prayers.py --require-signoff
python3 -m json.tool .factory/project-context.json
python3 -m json.tool quality/quality-manifest.json
./Scripts/build.sh
```

### Acceptance criteria

- Structural and sign-off validators pass.
- Release build, 74 or more unit/integration tests, and all current UI tests
  pass without unexplained skips.
- UI suite passes on compact iPhone, large iPhone, and iPad.
- CI passes on the candidate SHA.
- Archive inspection finds zero provisional audio and the expected privacy
  manifest, app icon, catalog, identifier, version/build, and deployment target.
- Any new warning is triaged; no failed command is hidden by a pipe.

### Required evidence

Create `quality/evidence/YYYY-MM-DD-tf-006-automated-gate.md`; retain logs under
`BuildReports/` or CI artifacts and link them. If one run is invalidated by
simulator interference, say so and retain only an isolated rerun as pass
evidence.

---

## TF-007 — Complete manual accessibility and device QA

**Status:** `blocked` until human QA and devices are assigned  
**Owner:** human QA/release owner  
**May an autonomous model finish it?** No. A model may guide and record, but
manual usability and real-device results require a person.

### Device matrix

- one supported compact iPhone on iOS 17 or the oldest available supported OS;
- one current large iPhone;
- one supported iPad, full screen and a narrow multitasking width;
- light mode and dark mode;
- fresh install and upgrade/reinstall behavior where practical.

### Subtasks

1. Copy `docs/templates/TESTFLIGHT_QA_EVIDENCE.md` to a dated TF-007 evidence
   file and fill every environment field.
2. Run VoiceOver through onboarding, Today, player modes, completion, Moments,
   Me, saved prayers, privacy, and all alerts. Confirm labels, traits, order,
   adjustable controls, and absence of traps.
3. Test the largest accessibility text size and representative intermediate
   sizes without clipped critical text or unreachable actions.
4. Enable Reduce Motion and confirm the primary path remains understandable.
5. Inspect contrast and color-independent meaning in all five time bands in
   light and dark appearance.
6. Test iPad full-screen and narrow multitasking layouts; record any overflow,
   excessive stretching, or unreachable control.
7. On a real device, test notification grant, denial, later Settings
   revocation, scheduling, repeated toggles, actual delivery, tap routing, and
   foreground/background transitions.
8. Test airplane mode from cold launch through completion and saved-prayer
   relaunch.
9. Test deep links from cold and warm state:
   `anjali://moment/anxiety` and
   `anjali://moment/beforeWork`.
10. Force quit and relaunch after onboarding, settings change, save, delete,
    and completion. Verify explicit persistence-degraded messaging if a
    controlled store failure can safely be induced.
11. Confirm Listen is absent because no exact approved human recording exists;
    Chant and Silent explain their sound behavior, show full text/meaning, and
    require explicit Begin and Complete. If a controlled approved-audio failure
    case is available later, confirm it remains unstarted and cannot create a
    completion.
12. Record defects with severity, reproduction steps, device/OS, expected and
    actual behavior, and screenshot/video where useful.

### Acceptance criteria

- Every matrix row is Pass, Not Applicable with reason, or linked to a resolved
  defect and retest.
- No open crash, data-loss, inaccessible-primary-path, content-safety, privacy,
  notification-state, or release-blocking layout defect remains.
- A named QA owner signs a go/no-go for the exact build.

### Required evidence

Use `docs/templates/TESTFLIGHT_QA_EVIDENCE.md`. Commit only redacted evidence.

---

## TF-008 — Create and inspect a signed distribution archive

**Status:** `blocked` on TF-002, TF-005, TF-006, and TF-007  
**Owner:** authorized signing/release owner  
**May an autonomous model finish it?** Only in an already authorized signing
environment and with explicit upload scope. Never export credentials.

### Purpose

Prove the candidate can be signed for App Store distribution and validates in
Xcode Organizer.

### Subtasks

1. Use Xcode 26 or later with an iOS 26 SDK.
2. Confirm the Release app target uses the approved team, automatic signing
   unless the account owner requires managed profiles, and exact bundle ID.
3. Confirm no unexpected entitlements/capabilities are present.
4. Select the generic iOS device/Any iOS Device archive destination and archive
   the exact TF-005 commit.
5. In Organizer, inspect archive identity: app, version, build, team, bundle ID,
   source-control commit if shown.
6. Run Validate App. Save all warnings/errors and resolve them without weakening
   privacy, signing, or content gates.
7. Inspect the signed archive for the expected icon, privacy manifest,
   `prayers.json`, zero provisional audio, and correct Info.plist values.
8. Confirm `ITSAppUsesNonExemptEncryption = NO` is still accurate. The account
   owner remains responsible for the export-compliance determination.

Useful read-only inspections after locating the signed `.app`:

```bash
codesign -d --entitlements :- "<SIGNED_ARCHIVE_APP_PATH>"
plutil -p "<SIGNED_ARCHIVE_APP_PATH>/Info.plist"
find "<SIGNED_ARCHIVE_APP_PATH>" -type f | sort
```

Do not paste signing identities, profiles, or full entitlement output into a
public issue without redaction.

### Acceptance criteria

- Signed App Store distribution archive succeeds from the recorded SHA.
- Organizer validation has no errors.
- Identity and entitlements match TF-002/TF-005.
- Bundle inspection has zero provisional audio and expected privacy/content
  files.
- Warnings are recorded and dispositioned.

### Required evidence

Create `quality/evidence/YYYY-MM-DD-tf-008-signed-archive.md` with archive date,
SHA, Xcode/SDK, version/build, team/bundle, validation result, entitlement
summary, bundle inspection, and redacted log location. Do not commit the signed
archive or credentials unless repository policy explicitly allows it.

---

## TF-009 — Upload, process, and clear compliance

**Status:** `blocked` on TF-004 and TF-008  
**Owner:** App Store Connect role Account Holder, Admin, App Manager, or
Developer

### Purpose

Deliver the signed binary and move it to a TestFlight-eligible Apple build
status.

### Subtasks

1. Upload the validated TF-008 archive through Organizer/Transporter using an
   authorized account. Do not select “TestFlight Internal Only” if external
   testing is planned.
2. Save the delivery/upload ID and timestamp.
3. Wait for processing. Apple says a build must process before appearing.
4. If upload fails before completing, fix the stated problem and follow App
   Store Connect's build-number behavior. After a successful upload, any
   replacement must use a new unique build number.
5. Resolve `Missing Compliance` honestly. Confirm the repository declaration
   and App Store Connect export-compliance answer agree.
6. Inspect processing warnings, privacy-manifest notices, icon/metadata
   warnings, supported devices, minimum OS, and build identity.
7. Confirm the build reaches a status eligible for internal testing and, when
   needed, Beta App Review. Escalate processing that remains stuck for more
   than 24 hours to Apple Developer Support.
8. Enter the approved Test Information from TF-004 and keep the repo copy
   synchronized.

### Acceptance criteria

- Upload is complete and the correct app/version/build appears in TestFlight.
- No unresolved processing, compliance, signing, privacy, or binary error
  remains.
- Delivery ID, upload time, final status, warnings, and resolutions are
  recorded.
- Build was not made internal-only if external testing is intended.

### Required evidence

Create `quality/evidence/YYYY-MM-DD-tf-009-upload-processing.md`. Redact Apple
IDs, emails, phone numbers, and tokens as necessary.

---

## TF-010 — Run internal TestFlight and record a go/no-go

**Status:** `blocked` on TF-009  
**Owner:** internal QA lead and App Store Connect operator  
**Apple constraint:** create an internal group before an external group.

### Purpose

Verify Apple's processed build—not a local archive—on real devices before
external review.

### Subtasks

1. Create an internal TestFlight group with the minimum authorized testers
   needed for QA. Do not add users only to inflate participation.
2. Add the processed build and enter build-specific What to Test text.
3. Install from TestFlight on at least one real iPhone and one real iPad.
4. Confirm displayed version/build matches TF-005.
5. Execute the TF-007 device checklist against the TestFlight binary, focusing
   on fresh install, onboarding, Moment/Intention/Deity discovery, Today →
   Chant/Silent → explicit Begin → explicit Complete, save and relaunch,
   reminder grant/deny/edit/rollback/delivery/tap, deep links, airplane mode,
   background/foreground, dark mode, and hidden Listen.
6. Review TestFlight crashes, screenshots, and tester feedback.
7. Log every defect in the repository first. Fixes require a new candidate,
   new build number, and reruns of TF-006 onward.
8. Have engineering, QA, product/content, and release owners record go/no-go.

### Acceptance criteria

- The exact processed build installs and launches through TestFlight on real
  iPhone and iPad.
- All critical paths pass; no release-blocking defect is open.
- Notification editing/delivery, offline, deep-link, persistence, explicit
  self-led completion, and hidden-Listen behavior pass on the TestFlight
  binary.
- Named owners record a go decision for external Beta App Review.

### Required evidence

Create `quality/evidence/YYYY-MM-DD-tf-010-internal-testflight.md` with group,
build, redacted tester/device matrix, results, feedback/crash review, defect
links, and signed go/no-go.

---

## TF-011 — Submit and clear external Beta App Review

**Status:** `blocked` on TF-001, TF-003, TF-004, and TF-010  
**Owner:** App Manager/Admin/authorized TestFlight operator

### Purpose

Obtain Apple's approval to distribute the build beyond App Store Connect users.

### Subtasks

1. Confirm TF-001 named content sign-off is green and the external scope is
   approved.
2. Create the first external group. Use email invitations for the controlled
   beta; do not enable a public link initially.
3. Add the build, the final What to Test text, and the TF-004 Test Information.
4. Verify Beta App Description, Feedback Email, review contact, privacy URL,
   accountless state, and notes exactly match the repository.
5. Submit the build for TestFlight App Review. Apple generally fully reviews
   the first build; do not promise a review duration.
   Only one build for a version can be in Beta App Review at a time, and Apple
   limits review submissions in a 24-hour period; diagnose a rejection before
   resubmitting.
6. Monitor status and App Review messages. Preserve the exact rejection or
   question text in restricted evidence.
7. Respond accurately. If code or metadata changes, update the repository,
   create a new build as required, and rerun affected gates.
8. Record approval and the build's 90-day expiration date.

### Acceptance criteria

- External group and exact approved build are identified.
- Test Information is complete and truthful.
- Beta App Review is approved with no unresolved message.
- Invitations are still withheld until TF-012's tester list and stop/go rules
  are approved.

### Required evidence

Create `quality/evidence/YYYY-MM-DD-tf-011-beta-review.md` with submission date,
build, group, status history, responses, approval date, and expiration date.

---

## TF-012 — Conduct controlled external beta and triage

**Status:** `blocked` on TF-011  
**Owner:** product owner, QA lead, cultural/content owner  
**Initial cohort:** 20–30 invited practitioners, including varied devices and
traditions; do not use a public link for the first cohort.

### Purpose

Validate cultural trust, core usability, real-world device behavior, and
release stability without claiming analytics the app does not collect.

### Subtasks

1. Approve the tester cohort and consent/contact process outside the repo.
2. Send email invitations to the external group in a small first wave.
3. Give testers the build-specific What to Test and feedback email.
4. Ask about prayer accuracy/respect, moment selection, text legibility,
   navigation, reminders, offline behavior, crashes, and confusing no-audio
   states. Do not claim an in-app rating form exists.
5. Review TestFlight feedback and crash diagnostics at least each business day
   during active testing. Do not add analytics solely to measure beta retention.
6. Triage findings into repository issues/tasks with severity:
   - P0: privacy/content harm, crash/data loss, unusable primary path;
   - P1: major accessibility, reminder-state, persistence, or navigation fault;
   - P2: material but avoidable defect;
   - P3: polish/future improvement.
7. Pause distribution for any P0, credible sacred-text error, privacy mismatch,
   or repeated data-loss/crash issue.
8. For a new binary, return to TF-005 with a new unique build. For metadata-only
   corrections, update TF-004 and App Store Connect, then record the change.
9. At the end of the cohort, publish a repo beta summary with counts of invited,
   installed (if available from TestFlight), completed feedback responses,
   severity totals, resolved/open defects, and go/no-go. Do not invent retention
   or ratings.
10. Stop testing expired/unsafe builds and remove access when appropriate.

### Acceptance criteria

- No open P0 or release-blocking P1 issue remains.
- All credible prayer/content feedback is reviewed by the named human content
  owner.
- TestFlight crash/feedback queues have been triaged.
- Product, QA, content, and release owners record a go/no-go for the next build
  or App Store submission.

### Required evidence

Create `quality/evidence/YYYY-MM-DD-tf-012-external-beta-summary.md`. Store
personal tester data outside Git; report only aggregated/redacted information.

---

## App Store submission follow-on (not all first-beta blockers)

Do not block the first internal TestFlight install on storefront work that
Apple does not require for it. Complete these before App Store submission and
earlier if App Store Connect explicitly prompts:

| ID | Follow-on task | Notes |
|---|---|---|
| AS-001 | Complete current age-rating questionnaire | Review every current question; `4+` is an expectation, not a pre-filled answer. |
| AS-002 | Confirm primary/secondary categories | Proposed: Lifestyle; Health & Fitness. Product owner decides. |
| AS-003 | Publish support URL and complete store privacy answers | “Data Not Collected” only if the final binary still matches. |
| AS-004 | Capture required iPhone/iPad screenshots | Store submission asset, not a first internal TestFlight prerequisite. |
| AS-005 | Finalize subtitle, description, keywords, promotional text, What's New | Remove audio claims while v1 is text-only. |
| AS-006 | Complete content-rights, DSA/trader, availability, price, and region-specific compliance | Account/legal owner actions; document China mainland decision. |
| AS-007 | Submit App Store version for review | Separate from TestFlight Beta App Review. |

See `AppStore/RELEASE_CHECKLIST.md` for the operational App Store sequence.

## Official Apple sources

Requirements were checked on 29 July 2026. Re-check before account actions
because App Store Connect fields and upload rules change.

- [Upload builds](https://developer.apple.com/help/app-store-connect/manage-builds/upload-builds/)
- [Add a new app](https://developer.apple.com/help/app-store-connect/create-an-app-record/add-a-new-app/)
- [App information reference](https://developer.apple.com/help/app-store-connect/reference/app-information/app-information/)
- [Register an App ID](https://developer.apple.com/help/account/identifiers/register-an-app-id/)
- [TestFlight overview](https://developer.apple.com/help/app-store-connect/test-a-beta-version/testflight-overview/)
- [Provide Test Information](https://developer.apple.com/help/app-store-connect/test-a-beta-version/provide-test-information)
- [Add internal testers](https://developer.apple.com/help/app-store-connect/test-a-beta-version/add-internal-testers/)
- [Invite external testers](https://developer.apple.com/help/app-store-connect/test-a-beta-version/invite-external-testers)
- [Build upload statuses](https://developer.apple.com/help/app-store-connect/reference/app-uploads/build-upload-statuses)
- [App build statuses](https://developer.apple.com/help/app-store-connect/reference/app-build-statuses/)
- [Export compliance overview](https://developer.apple.com/help/app-store-connect/manage-app-information/overview-of-export-compliance)
- [Manage App Privacy](https://developer.apple.com/help/app-store-connect/manage-app-information/manage-app-privacy)
- [Set an app age rating](https://developer.apple.com/help/app-store-connect/manage-app-information/set-an-app-age-rating)
- [App Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)
- [Upcoming submission requirements](https://developer.apple.com/news/upcoming-requirements/?id=02032026a)
