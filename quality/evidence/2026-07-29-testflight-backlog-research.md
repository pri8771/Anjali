# TestFlight Backlog Research Evidence

Date: 29 July 2026  
Scope: repository documentation and external TestFlight readiness planning  
Product lifecycle after this work: `verification_pending`

## Result

The repository now has an ordered, execution-ready TestFlight backlog
(`docs/TESTFLIGHT_READINESS_BACKLOG.md`), a beta metadata packet
(`AppStore/testflight_metadata.md`), and a manual/device evidence template
(`docs/templates/TESTFLIGHT_QA_EVIDENCE.md`).

This work does not claim that any Apple-account, content-review, signed-build,
device, upload, or Beta App Review gate has passed.

## Repository facts used

- Factory project type is `existing`; standard version is 0.2.0.
- Lifecycle is `verification_pending`.
- App target: iOS 17+, iPhone/iPad, bundle `app.anjali.Anjali`, version 1.0,
  local build 1, automatic signing, configured team `796XH483R4`.
- Current automated evidence: 58 unit/integration and 4 UI tests green on the
  large iPhone; UI suite also green on compact iPhone and iPad; unsigned arm64
  archive green.
- Content structure passes 22/22; named human sign-off is 0/22.
- Twenty provisional audio files are repository-only and absent from the app
  target/catalog/archive.
- App is offline/accountless with no third-party SDK, analytics, ads, IAP, or
  network layer.
- Public privacy/support URLs and monitored beta contact are missing.
- Signing ownership, App Store Connect record, unique uploaded build history,
  device QA, signed validation, processing, and TestFlight status are unknown.

## Official-source findings applied

All links were checked on the evidence date. App Store Connect changes over
time, so TF-002/TF-009 owners must re-check before mutating account state.

1. Apple requires an app record before uploading. Bundle ID and version
   associate the build; the build string uniquely identifies it. Roles are
   limited.  
   Source: [Upload builds](https://developer.apple.com/help/app-store-connect/manage-builds/upload-builds/)
2. Creating an app record requires current agreements and name, primary
   language, bundle ID, SKU, and user access.  
   Source: [Add a new app](https://developer.apple.com/help/app-store-connect/create-an-app-record/add-a-new-app/)
3. Bundle ID and SKU choices have important immutability constraints; Content
   Rights and region-specific compliance fields require owner/legal decisions.  
   Source: [App information reference](https://developer.apple.com/help/app-store-connect/reference/app-information/app-information/)
4. External testing needs additional Test Information, including Beta App
   Description and Feedback Email.  
   Source: [Provide Test Information](https://developer.apple.com/help/app-store-connect/test-a-beta-version/provide-test-information)
5. TestFlight builds are available for up to 90 days; Apple supports up to 100
   internal users and 10,000 external testers. Those limits are not project
   targets.  
   Source: [TestFlight overview](https://developer.apple.com/help/app-store-connect/test-a-beta-version/testflight-overview/)
6. An internal group must exist before an external group. External groups need
   a build and What to Test text; the first external build generally receives a
   full Beta App Review. Public links are optional, so Anjali starts with email
   invitations.  
   Sources: [Add internal testers](https://developer.apple.com/help/app-store-connect/test-a-beta-version/add-internal-testers/),
   [Invite external testers](https://developer.apple.com/help/app-store-connect/test-a-beta-version/invite-external-testers)
7. Processing/compliance status is separate from upload success. Processing
   longer than 24 hours should be escalated to Apple Support.  
   Sources: [Build upload statuses](https://developer.apple.com/help/app-store-connect/reference/app-uploads/build-upload-statuses),
   [App build statuses](https://developer.apple.com/help/app-store-connect/reference/app-build-statuses/)
8. The developer remains responsible for export-compliance answers even though
   this repo sets `ITSAppUsesNonExemptEncryption = NO`.  
   Source: [Export compliance overview](https://developer.apple.com/help/app-store-connect/manage-app-information/overview-of-export-compliance)
9. A privacy-policy URL is required for all apps, and App Privacy responses must
   match the actual binary.  
   Source: [Manage App Privacy](https://developer.apple.com/help/app-store-connect/manage-app-information/manage-app-privacy)
10. Age rating is a current questionnaire. `4+` is an expected outcome, not a
    value to force with unreviewed “None” answers.  
    Source: [Set an app age rating](https://developer.apple.com/help/app-store-connect/manage-app-information/set-an-app-age-rating)
11. From 28 April 2026, iOS uploads require Xcode 26+ and an iOS 26 SDK. Current
    local evidence uses Xcode 26.6/iOS 26.5 and meets that baseline.  
    Source: [Upcoming requirements](https://developer.apple.com/news/upcoming-requirements/?id=02032026a)

## Corrections made to repository planning

- Removed unsupported beta checkmarks, fixed week promises, server-load claims,
  invented in-app feedback, and analytics-dependent retention targets.
- Replaced query-style deep-link examples with implemented path-style URLs.
- Stated that v1 is text-only and removed copy that implied audio ships.
- Separated screenshots, full storefront metadata, categories, age rating,
  price/availability, DSA, and regional compliance as App Store follow-ons.
- Added beta-specific description, feedback email, review contact/notes,
  accountless state, and What to Test requirements.
- Added explicit human/account boundaries, dependencies, rollback rules,
  acceptance criteria, and evidence paths for TF-001–TF-012.

## Verification performed

- Read all factory registration/rules/quality files and relevant feature
  contracts.
- Read release, status, test, architecture, risk, assumption, handoff, content,
  beta, policy, and listing documents.
- Inspected Xcode build identity and Info.plist values.
- Inspected CI and local build scripts to avoid inventing commands.
- Checked repository JSON syntax and Markdown whitespace with local tools.
- Searched the repo for stale deep links, “reviewed” claims, unsupported beta
  metrics, and App Store/TestFlight conflation.

## Intentionally open

- Human content review, public values, and account decisions.
- Signed archive/upload, processing/export compliance, internal/external
  TestFlight, and real-device QA.
- Store screenshots, age rating, category, privacy response, DSA/trader,
  content-rights, availability, and region decisions.
