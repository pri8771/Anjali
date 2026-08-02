# TF-002 Apple Identity — Repository Preflight

**Date:** 2026-07-29  
**Scope:** Repository-only preflight for TF-002. This record does not access, verify, or modify Apple Developer, App Store Connect, public storefront, or any other Apple account state.  
**Status:** `verification_pending` — TF-002 remains `blocked` pending the authorized Account Holder/Admin work listed below.

## Local source inspected

- Working-tree baseline commit: `93e9826f43a08dd31dbb42fbcd8c2620e635e309`.
- The worktree contained pre-existing modifications at inspection time, including the Xcode project and Info.plist. Therefore the facts below describe the inspected local working tree, not a clean release candidate.
- App target: `Anjali` in `Anjali/Anjali.xcodeproj`.
- Files inspected: `project.pbxproj`, `Anjali/Info.plist`, `Anjali/PrivacyInfo.xcprivacy`, and repository dependency/entitlement manifests.

## Verified repository facts

| Surface | Debug | Release | Repository finding |
|---|---|---|---|
| Development team | `796XH483R4` | `796XH483R4` | Matches across app-target configurations; ownership is not proven locally. |
| Bundle identifier | `app.anjali.Anjali` | `app.anjali.Anjali` | Matches across app-target configurations. |
| Marketing version | `1.0` | `1.0` | Info.plist resolves `CFBundleShortVersionString` from `$(MARKETING_VERSION)`. |
| Build number | `1` | `1` | Info.plist resolves `CFBundleVersion` from `$(CURRENT_PROJECT_VERSION)`. |
| Signing style | `Automatic` | `Automatic` | No local provisioning-profile UUID/specifier is configured in the app target. |
| Entitlements | — | — | No `*.entitlements` file exists; no `CODE_SIGN_ENTITLEMENTS` setting appears in the app-target configurations. |
| Capability/dependency surface | — | — | No Swift Package, CocoaPods, or Carthage manifest is present. Architecture declares no third-party dependencies or backend. `UserNotifications` is used for opt-in **local** reminders. |
| URL scheme | — | — | `CFBundleURLTypes` declares name `app.anjali.deeplink` and scheme `anjali`. |
| Export compliance | — | — | `ITSAppUsesNonExemptEncryption` is `false` (`NO`). This is a repository declaration only; the Account Holder must answer any upload-time questions accurately. |
| Privacy manifest | — | — | `PrivacyInfo.xcprivacy` declares tracking `false`, no tracking domains, no collected data types, and UserDefaults required-reason API `CA92.1`. The synchronized app root includes this file (it is not listed as a membership exception). |
| Devices / minimum OS | `TARGETED_DEVICE_FAMILY = 1,2`; iOS `17.0` | same | iPhone and iPad are targeted. Info.plist provides portrait-only iPhone orientations and all four common iPad orientations. |

### Capability reconciliation needed in the Apple portal

The local project has no entitlement-backed capability. The only apparent Apple-service-adjacent API is `UNUserNotificationCenter` for local calendar notifications. Local notifications do **not** require the Push Notifications capability. The authorized portal reviewer must nevertheless compare the App ID capability list and ensure it contains no unexpected Push Notifications, iCloud, Associated Domains, App Groups, Sign in with Apple, HealthKit, payment, or other capabilities. This preflight cannot see portal configuration.

## Commands and observed results

All commands were run from `/Users/pchordia/Documents/other/ios_apps/Anjali`.

```sh
rg -n -C 3 'PRODUCT_BUNDLE_IDENTIFIER|DEVELOPMENT_TEAM|MARKETING_VERSION|CURRENT_PROJECT_VERSION|CODE_SIGN_ENTITLEMENTS|CODE_SIGN_STYLE|TARGETED_DEVICE_FAMILY|INFOPLIST_FILE|SystemCapabilities|com\.apple' Anjali/Anjali.xcodeproj/project.pbxproj
```

Result: in both the `Anjali` target Debug and Release configurations, `CODE_SIGN_STYLE = Automatic`, `CURRENT_PROJECT_VERSION = 1`, `DEVELOPMENT_TEAM = 796XH483R4`, `INFOPLIST_FILE = Anjali/Info.plist`, `IPHONEOS_DEPLOYMENT_TARGET = 17.0`, `MARKETING_VERSION = 1.0`, `PRODUCT_BUNDLE_IDENTIFIER = app.anjali.Anjali`, and `TARGETED_DEVICE_FAMILY = "1,2"`. No `CODE_SIGN_ENTITLEMENTS`, `SystemCapabilities`, or `com.apple.*` entitlement configuration was returned for the app target.

```sh
plutil -p Anjali/Anjali/Info.plist
```

Result: parse succeeded. The file contains display name `Anjali`, bundle ID, short version, and build placeholders noted above; URL name `app.anjali.deeplink` with scheme `anjali`; and `ITSAppUsesNonExemptEncryption => false`.

```sh
plutil -p Anjali/Anjali/PrivacyInfo.xcprivacy
```

Result: parse succeeded. `NSPrivacyTracking => false`, empty tracking-domain and collected-data arrays, and one accessed API declaration: `NSPrivacyAccessedAPICategoryUserDefaults` with reason `CA92.1`.

```sh
find Anjali -type f -name '*.entitlements' -print
find . -maxdepth 4 -type f \( -name 'Package.swift' -o -name 'Package.resolved' -o -name 'Podfile' -o -name 'Podfile.lock' -o -name 'Cartfile' -o -name 'Cartfile.resolved' \) -print
```

Result: both commands produced no file paths.

```sh
rg -n '^import (CloudKit|StoreKit|PassKit|HealthKit|AuthenticationServices|UserNotifications)|UNUserNotificationCenter|CKContainer|ASAuthorization|HKHealthStore|PKPushRegistry|registerForRemoteNotifications' Anjali/Anjali
```

Result: `UserNotifications` imports and `UNUserNotificationCenter` references occur in `AnjaliApp.swift` and `Engine/NotificationManager.swift`; no matches were returned for CloudKit, StoreKit, PassKit, HealthKit, AuthenticationServices, remote-notification registration, or PushKit.

```sh
git rev-parse HEAD
git status --short
date -u '+%Y-%m-%dT%H:%M:%SZ'
```

Result: commit `93e9826f43a08dd31dbb42fbcd8c2620e635e309`; the worktree was dirty before this evidence was added; inspection timestamp `2026-07-29T19:45:53Z`.

An attempted `xcodebuild -showBuildSettings` query emitted environment-level CoreSimulator/Xcode cache and provisioning-profile loading warnings in this sandbox. It is not treated as signing or account evidence. The static project and plist results above are the authoritative preflight findings.

## Live release-environment check

The current Mac was also checked on 2026-07-29 without changing the keychain,
Xcode accounts, or Apple account state.

```sh
security find-identity -v -p codesigning
find "$HOME/Library/MobileDevice/Provisioning Profiles" \
  -maxdepth 1 -type f -print
```

Observed result: `security` reported `0 valid identities found`; the
provisioning-profile search returned no files. This does not disprove that the
team owns distribution assets in the Apple portal, but it does prove that this
Mac cannot currently create the signed App Store archive required by TF-008.
An authorized signing owner must install or allow Xcode to obtain the intended
distribution certificate/private key and App Store provisioning profile before
TF-008 can start.

App Store Connect was opened read-only in both the in-app browser and the
user's Chrome profile. Both displayed Apple's unauthenticated sign-in screen,
so no membership, agreement, role, App ID, app record, build-number, or portal
capability fact was available to inspect. The Chrome handoff tab was left open
for the account owner to authenticate personally; no credential was entered or
read by the agent.

## Account Holder/Admin handoff — required fields

Do not commit credentials, personal email addresses, provisioning private keys, tester lists, or unredacted account screenshots. Put restricted screenshots in authorized storage and reference their location, verifier, and date below.

| Subtask | Authorized operator must verify or choose | Required handoff value / evidence | Current state |
|---|---|---|---|
| TF-002.1 membership, agreements, roles | Intended organization has active Developer Program membership through beta; Account Holder has accepted all blocking agreements; authorized owners are assigned for account, App Store Connect, upload, and release actions. | Organization display name; verification date; Account Holder/Admin/App Manager/Developer role mapping (names may remain restricted); redacted restricted-evidence reference. | Unknown — external account state not inspected. |
| TF-002.2 team and explicit App ID | Team `796XH483R4` is the intended team and owns/has an explicit App ID exactly `app.anjali.Anjali`. | Portal App ID description, identifier, operator, verification date, and match statement. Stop if another team owns it. | Local match only; portal ownership/App ID unknown. |
| TF-002.3 capabilities/signing | App ID portal capabilities exactly match the local surface: no entitlement-backed capability is expected; local notifications must not enable Push Notifications. Confirm automatic signing can select an appropriate distribution profile/certificate later. | Redacted capability matrix; reviewer/date; any exception approved by engineering/privacy. | Portal capabilities and distribution signing assets unknown. |
| TF-002.4 app record | Search first; exactly one iOS App Store Connect record exists or is created with final approved values. | App Apple ID; final name; primary language; stable non-sensitive SKU; explicit user access; creator/date; later upload operator access confirmation. | App record, App Apple ID, language, SKU, access, and access rights unknown. Do not create with guessed values. |
| TF-002.5 name and content rights | Product/legal owner assesses the confusingly similar accented `ANJĀLI` listing, approves final store name, and documents the rights basis for bundled prayer text/translation. | Decision owner/date; final name; concise rights basis; restricted legal reference if needed; honest Content Rights answer when prompted. | Name is locally `Anjali`; clearance/approval and rights decision unknown. |
| TF-002.6 regions/compliance | Account/legal owner selects initial beta/store regions and evaluates Apple compliance prompts. China mainland remains excluded unless the owner documents the religious-information permit decision and any required evidence. | Approved region matrix; owner/date; compliance notes; restricted permit reference if applicable. | Regions and compliance decisions unknown. `ASM-007` proposes China mainland excluded initially. |
| TF-002.7 reconciliation | Reconcile the completed account facts with this preflight and create the task's final redacted identity evidence. | Team, bundle, app name, App ID, App Apple ID, language, SKU, access, capabilities, rights, agreement status, regions; verifier/owner/date and restricted-evidence reference. | Cannot complete until TF-002.1–.6 are verified by authorized people. |

## Explicit unknowns / blockers

- Whether `796XH483R4` is owned by the intended organization and has active membership and accepted agreements.
- Whether the explicit App ID exists, who owns it, and its portal capability configuration.
- Whether a unique, accessible App Store Connect record exists; its Apple ID, SKU, primary language, access setting, and authorized release operators.
- Final approved store name, name-confusion/trademark assessment, and bundled content-rights basis.
- Initial distribution regions and all account/legal compliance answers, including China mainland.
- Portal distribution certificate/provisioning availability and any final
  selection. Independently, this Mac currently has zero valid code-signing
  identities and no installed provisioning profiles.

These are human/account decisions or external facts. They prevent TF-002 from being marked complete. This preflight is intentionally only repository-safe evidence and does not alter the canonical backlog or task brief.
