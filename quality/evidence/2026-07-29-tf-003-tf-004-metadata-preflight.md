# TF-003.1 / TF-004 metadata preflight

> Historical preflight. Current consumer behavior supersedes the Listen
> fallback described below: normal builds hide Listen without an exact approved
> human recording. See
> [`2026-07-30-daily-use-consumer-pass.md`](2026-07-30-daily-use-consumer-pass.md).

**Date:** 2026-07-29
**Scope:** repository-safe preflight for TF-003.1 and TF-004.1, TF-004.2,
TF-004.4, and TF-004.5 only.
**Result:** `verification_pending` — the source-backed copy is reconciled, but
human approval, a frozen candidate identity, public URLs, contacts, and
candidate/device verification remain outstanding.

## Scope and claim-to-source matrix

| Metadata/policy claim | Repository evidence | Preflight result |
|---|---|---|
| iOS 17+, iPhone and iPad | `Anjali/Anjali.xcodeproj/project.pbxproj` deployment target/build settings; `Anjali/Anjali/Info.plist` has iPhone and iPad orientation declarations | Supported by project configuration; still confirm against the frozen archive. |
| Offline; no backend/network service | `docs/ARCHITECTURE.md` states no backend/network client; search of production Swift/plist/privacy-manifest sources found no `URLSession`, `NWPath`, Firebase, analytics, ads, StoreKit, or tracking API. | Supported by static source audit, not a runtime packet capture. |
| No account/sign-in; Sign-in Required = No | `docs/FEATURES.md` excludes accounts; `Anjali/Anjali/Views/RootView.swift` selects only onboarding or main tabs; `Anjali/Anjali/AnjaliApp.swift` contains no authentication flow. | Supported. No demo account should be entered. |
| No analytics, advertising, purchases, tracking, collected/transmitted user data | `Anjali/Anjali/PrivacyInfo.xcprivacy` declares `NSPrivacyTracking=false` and no collected data types; `docs/ARCHITECTURE.md` declares no dependencies/backend/network client; project file has no package reference. | Supported by repository static audit. Legal/product approval is still required before publication. |
| Preferences stored locally in UserDefaults | `Anjali/Anjali/Engine/AppSettings.swift` persists onboarding, script/mode, deity, favorite moments, and reminder slots with `UserDefaults`. | Supported; accurately described by `AppStore/privacy_policy.md`. |
| Completions and saved prayers stored locally in SwiftData | `Anjali/Anjali/AnjaliApp.swift` creates `ModelContainer` for `PrayerCompletion` and `FavoritePrayer`; `Anjali/Anjali/Models/UserData.swift` defines those local models; `docs/ARCHITECTURE.md` confirms on-device use. | Supported. |
| Optional local reminders; permission follows explicit opt-in; denial does not block use | `Anjali/Anjali/Engine/NotificationManager.swift` uses `UNUserNotificationCenter` calendar requests; `Views/Onboarding/OnboardingView.swift` and `Views/Me/MeView.swift` call authorization only from reminder-enable paths; `quality/feature-contracts/FEAT-003-local-reminders.json` specifies denial/recovery behavior. | Supported; real-device delivery/denial remains TF-007 evidence. |
| Prayer content is bundled locally | `Anjali/Anjali/Engine/PrayerDataLoader.swift` reads bundled `prayers.json`; `Anjali/Anjali/Engine/PrayerLibrary.swift` documents no network path. | Supported. |
| Text-only beta and Listen fallback | All 22 `audioAssetName` values in `Anjali/Anjali/Resources/prayers.json` are `null`; `Anjali/Anjali.xcodeproj/project.pbxproj` excludes every `Resources/Audio/*` file from target membership; `PlayerController.swift` sets `audioUnavailable` when no asset is available; `PrayerPlayerView.swift` displays “Audio isn't available — follow along in silence.” | Supported for current source. The prior unsupported “reviewed recording” and “synthetic/generated audio” language was removed from the metadata. Reconfirm by inspecting the release archive. |
| Browse by moment/deity; Chant/Silent/Listen; save and complete flows | `docs/FEATURES.md`; `quality/feature-contracts/FEAT-001-prayer-experience.json`; `Views/Moments`, `Views/Player`, and SwiftData models. | Supported at source level; functional/device testing remains open. |
| Supported deep links | `Info.plist` registers scheme `anjali`; `Engine/DeepLink.swift` supports `anjali://moment/{id}`; `Models/Enums.swift` defines `anxiety` and `beforeWork`; `AnjaliApp.swift` routes `onOpenURL` to `AppCoordinator`. | `anjali://moment/anxiety` and `anjali://moment/beforeWork` are supported. Both need candidate-device execution evidence. |
| Suggested review path | `RootView.swift`, `TodayView.swift`, and `PrayerPlayerView.swift` expose onboarding/main tabs, Today, player, Silent, Complete, and Done. | Source-supported, but record a candidate run before Apple submission. |

## Copy corrections made

`AppStore/testflight_metadata.md` was corrected in two places:

1. “a reviewed recording is not yet available” became “audio is not available.”
   The implementation identifies unavailable audio, not review status.
2. “never plays synthetic/generated audio” became “plays no audio in this
   text-only build.” The source proves no shipping audio for this candidate
   scope; it does not establish an audio-production provenance category.

No build number, commit SHA, URL, mailbox, contact, App Store Connect identity,
or tester-group value was filled.

## Policy and terms reconciliation

`AppStore/privacy_policy.md` matches the source-backed local storage,
notification, offline, accountless, and no-tracking claims above. Its public
contact/support wording cannot be approved until a real public support URL and
contact owner are supplied (TF-003.2–.5).

`AppStore/terms_of_service.md` makes content-rights/licensing statements that
cannot be proven from application source. They require product/legal/content
owner approval and content-rights evidence; this preflight did not treat them
as established facts. Its contact and effective-date language also requires
human approval.

## Exact checks run

```sh
plutil -p Anjali/Anjali/Info.plist
plutil -p Anjali/Anjali/PrivacyInfo.xcprivacy
rg -n 'URLSession|NSURLSession|http://|https://|NWPath|Alamofire|Firebase|Sentry|StoreKit|SKPayment|AdSupport|AppTrackingTransparency|CoreTelephony' Anjali/Anjali --glob '*.{swift,plist,xcprivacy}'
rg -n 'XCRemoteSwiftPackageReference|packageProductDependencies|PBXFileSystemSynchronizedBuildFileExceptionSet|Resources/Audio' Anjali/Anjali.xcodeproj/project.pbxproj
rg -n '"audioAssetName": null' Anjali/Anjali/Resources/prayers.json | wc -l
rg -n 'CFBundleURLSchemes|anjali' Anjali/Anjali/Info.plist Anjali/Anjali/Engine/DeepLink.swift Anjali/Anjali/AnjaliApp.swift
rg -n 'ModelContainer|UserDefaults|UNUserNotificationCenter|requestAuthorization|onOpenURL|audioUnavailable|Audio isn' Anjali/Anjali --glob '*.swift'
rg -n 'TBD|\\[[A-Z][A-Z0-9 _-]+\\]' AppStore/testflight_metadata.md
git diff --no-index --check /dev/null AppStore/testflight_metadata.md
git diff --no-index --check /dev/null quality/evidence/2026-07-29-tf-003-tf-004-metadata-preflight.md
```

The network-pattern search returned only XML DTD URLs in plist headers, not an
application network client. The audio-null count was `22`. The placeholder
search intentionally still reports unresolved human/account/build fields.

## Unresolved human/account inputs

- Privacy/product owner approval of the policy and terms, including actual
  effective date and rights/licensing assertions.
- Stable public HTTPS privacy-policy URL and support-URL decision, with
  signed-out desktop/mobile verification (TF-003.2/.4/.5).
- Monitored beta feedback mailbox, owner/backup, external send/reply test, and
  review-contact values entered privately in App Store Connect (TF-003.3,
  TF-004.3).
- TF-005 exact build number and release commit SHA.
- Named product, content, privacy, engineering, QA, and release approvals.
- Candidate archive inspection plus real-device checks for notification
  delivery/denial, both deep links, no-audio fallback, airplane mode,
  accessibility, and the primary review path.

## Safe next handoff

1. Do not replace any metadata placeholders until corresponding approved TF
   evidence exists.
2. After TF-005, insert only the exact build number and full SHA from its
   evidence; inspect the archive to reconfirm excluded audio and privacy
   manifest claims.
3. Have engineering/privacy review the final Review Notes and QA execute every
   What-to-Test item on the processed candidate.
4. Have the authorized operator enter the approved packet in App Store Connect;
   a second verifier must compare saved values with the final packet revision.
