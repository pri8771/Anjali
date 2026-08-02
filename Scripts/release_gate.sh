#!/usr/bin/env bash
set -euo pipefail

# Exact-commit, unsigned engineering release gate. This script does not create
# distribution evidence and cannot replace signed archive/TestFlight checks.
cd "$(dirname "$0")/.."

PROJECT="Anjali/Anjali.xcodeproj"
SCHEME="Anjali"
ACTUAL_SHA="$(git rev-parse HEAD)"
SHORT_SHA="$(git rev-parse --short=12 HEAD)"
RUN_STAMP="$(date -u +%Y%m%dT%H%M%SZ)"
REPORTS="${RELEASE_GATE_REPORTS:-BuildReports/release-gate/${SHORT_SHA}-${RUN_STAMP}}"
ENVIRONMENT_LOG="$REPORTS/environment.txt"
DESTINATIONS_TSV="$REPORTS/destinations.tsv"

mkdir -p "$REPORTS"

if [[ -n "${EXPECTED_SHA:-}" ]]; then
  NORMALIZED_EXPECTED_SHA="$(printf '%s' "$EXPECTED_SHA" | tr '[:upper:]' '[:lower:]')"
  if [[ "$ACTUAL_SHA" != "$NORMALIZED_EXPECTED_SHA" ]]; then
    echo "Expected candidate $EXPECTED_SHA, but checkout is $ACTUAL_SHA." >&2
    exit 1
  fi
fi

if [[ -n "$(git status --short)" ]]; then
  echo "The exact-commit release gate requires a clean checkout." >&2
  git status --short >&2
  exit 1
fi

{
  echo "candidate_sha=$ACTUAL_SHA"
  echo "started_at_utc=$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo "runner_arch=$(uname -m)"
  sw_vers
  xcodebuild -version
  xcrun simctl list runtimes
  xcodebuild -showdestinations -project "$PROJECT" -scheme "$SCHEME"
} 2>&1 | tee "$ENVIRONMENT_LOG"

if [[ "${SKIP_CONTENT_GATES:-0}" != "1" ]]; then
  python3 Scripts/validate_prayers.py 2>&1 | tee "$REPORTS/content-structural.log"
  python3 Scripts/validate_prayers.py --require-signoff 2>&1 |
    tee "$REPORTS/content-signoff.log"
fi

xcrun simctl list devices available -j >"$REPORTS/simctl-devices.json"

python3 - "$REPORTS/simctl-devices.json" "$DESTINATIONS_TSV" <<'PY'
import json
import re
import sys

source, destination = sys.argv[1:]
with open(source, encoding="utf-8") as handle:
    runtimes = json.load(handle).get("devices", {})

def runtime_version(identifier):
    match = re.search(r"\.iOS-(\d+)-(\d+)(?:-(\d+))?$", identifier)
    return tuple(map(int, match.groups(default="0"))) if match else None

ios_runtimes = [
    (version, identifier, devices)
    for identifier, devices in runtimes.items()
    if (version := runtime_version(identifier)) is not None
]
if not ios_runtimes:
    raise SystemExit("No available iOS simulator runtime was found.")

_, runtime, devices = max(ios_runtimes, key=lambda row: row[0])
available = [device for device in devices if device.get("isAvailable", True)]
iphones = sorted(
    (device for device in available if device.get("name", "").startswith("iPhone")),
    key=lambda device: (device["name"], device["udid"]),
)
ipads = sorted(
    (device for device in available if device.get("name", "").startswith("iPad")),
    key=lambda device: (device["name"], device["udid"]),
)
if len(iphones) < 2:
    raise SystemExit(
        "Responsive matrix requires at least two available iPhone simulators."
    )
if not ipads:
    raise SystemExit("Responsive matrix requires an available iPad simulator.")

def compact_rank(device):
    name = device["name"]
    compact_hint = bool(re.search(r"(?:\bSE\b|\bmini\b|\b\d+e\b)", name))
    large_hint = any(token in name for token in ("Pro Max", "Plus", "Ultra"))
    pro_hint = " Pro" in name
    return (0 if compact_hint else 1, 1 if large_hint else 0, 1 if pro_hint else 0, name)

def large_rank(device):
    name = device["name"]
    very_large = any(token in name for token in ("Pro Max", "Plus", "Ultra"))
    pro = " Pro" in name
    compact_hint = bool(re.search(r"(?:\bSE\b|\bmini\b|\b\d+e\b)", name))
    return (1 if very_large else 0, 1 if pro else 0, 0 if compact_hint else 1, name)

compact = min(iphones, key=compact_rank)
large = max(iphones, key=large_rank)
if compact["udid"] == large["udid"]:
    alternatives = [device for device in iphones if device["udid"] != compact["udid"]]
    large = max(alternatives, key=large_rank)
iPad = ipads[0]

with open(destination, "w", encoding="utf-8") as handle:
    for role, device in (("large", large), ("compact", compact), ("ipad", iPad)):
        handle.write(f"{role}\t{device['udid']}\t{device['name']}\t{runtime}\n")
PY

while IFS=$'\t' read -r role udid name runtime; do
  case "$role" in
    large) LARGE_UDID="$udid"; LARGE_NAME="$name" ;;
    compact) COMPACT_UDID="$udid"; COMPACT_NAME="$name" ;;
    ipad) IPAD_UDID="$udid"; IPAD_NAME="$name" ;;
  esac
  echo "$role: $name ($udid), $runtime" | tee -a "$ENVIRONMENT_LOG"
done <"$DESTINATIONS_TSV"

: "${LARGE_UDID:?large iPhone selection missing}"
: "${COMPACT_UDID:?compact iPhone selection missing}"
: "${IPAD_UDID:?iPad selection missing}"

DERIVED_DATA="$REPORTS/DerivedData"

set -o pipefail
xcodebuild clean build \
  -project "$PROJECT" \
  -scheme "$SCHEME" \
  -configuration Release \
  -destination "platform=iOS Simulator,id=$LARGE_UDID" \
  -derivedDataPath "$DERIVED_DATA" 2>&1 |
  tee "$REPORTS/large-iphone-release-build.log"

xcodebuild test \
  -project "$PROJECT" \
  -scheme "$SCHEME" \
  -destination "platform=iOS Simulator,id=$LARGE_UDID" \
  -derivedDataPath "$DERIVED_DATA" \
  -resultBundlePath "$REPORTS/large-iphone-full.xcresult" 2>&1 |
  tee "$REPORTS/large-iphone-full.log"
xcrun xcresulttool get test-results summary \
  --path "$REPORTS/large-iphone-full.xcresult" \
  >"$REPORTS/large-iphone-full-summary.json"

xcodebuild test \
  -project "$PROJECT" \
  -scheme "$SCHEME" \
  -destination "platform=iOS Simulator,id=$COMPACT_UDID" \
  -derivedDataPath "$DERIVED_DATA" \
  -only-testing:AnjaliUITests \
  -resultBundlePath "$REPORTS/compact-iphone-ui.xcresult" 2>&1 |
  tee "$REPORTS/compact-iphone-ui.log"
xcrun xcresulttool get test-results summary \
  --path "$REPORTS/compact-iphone-ui.xcresult" \
  >"$REPORTS/compact-iphone-ui-summary.json"

xcodebuild test \
  -project "$PROJECT" \
  -scheme "$SCHEME" \
  -destination "platform=iOS Simulator,id=$IPAD_UDID" \
  -derivedDataPath "$DERIVED_DATA" \
  -only-testing:AnjaliUITests \
  -resultBundlePath "$REPORTS/ipad-ui.xcresult" 2>&1 |
  tee "$REPORTS/ipad-ui.log"
xcrun xcresulttool get test-results summary \
  --path "$REPORTS/ipad-ui.xcresult" \
  >"$REPORTS/ipad-ui-summary.json"

ARCHIVE_PATH="$REPORTS/Anjali.xcarchive"
xcodebuild archive \
  -project "$PROJECT" \
  -scheme "$SCHEME" \
  -configuration Release \
  -destination "generic/platform=iOS" \
  -archivePath "$ARCHIVE_PATH" \
  -derivedDataPath "$DERIVED_DATA-archive" \
  CODE_SIGNING_ALLOWED=NO 2>&1 |
  tee "$REPORTS/unsigned-archive.log"

APP_PATH="$ARCHIVE_PATH/Products/Applications/Anjali.app"
INFO_PLIST="$APP_PATH/Info.plist"
PRAYERS_JSON="$APP_PATH/prayers.json"
PRIVACY_MANIFEST="$APP_PATH/PrivacyInfo.xcprivacy"

test -f "$INFO_PLIST"
test -f "$PRAYERS_JSON"
test -f "$PRIVACY_MANIFEST"

xcodebuild -showBuildSettings \
  -project "$PROJECT" \
  -scheme "$SCHEME" \
  -configuration Release \
  -destination "generic/platform=iOS" >"$REPORTS/release-build-settings.txt"

setting() {
  awk -F ' = ' -v key="$1" '$1 ~ "^[[:space:]]*" key "$" {print $2; exit}' \
    "$REPORTS/release-build-settings.txt"
}

EXPECTED_BUNDLE_ID="$(setting PRODUCT_BUNDLE_IDENTIFIER)"
EXPECTED_VERSION="$(setting MARKETING_VERSION)"
EXPECTED_BUILD="$(setting CURRENT_PROJECT_VERSION)"
EXPECTED_MINIMUM_OS="$(setting IPHONEOS_DEPLOYMENT_TARGET)"

ACTUAL_BUNDLE_ID="$(plutil -extract CFBundleIdentifier raw "$INFO_PLIST")"
ACTUAL_VERSION="$(plutil -extract CFBundleShortVersionString raw "$INFO_PLIST")"
ACTUAL_BUILD="$(plutil -extract CFBundleVersion raw "$INFO_PLIST")"
ACTUAL_MINIMUM_OS="$(plutil -extract MinimumOSVersion raw "$INFO_PLIST")"
ACTUAL_ENCRYPTION="$(plutil -extract ITSAppUsesNonExemptEncryption raw "$INFO_PLIST")"

[[ "$ACTUAL_BUNDLE_ID" == "$EXPECTED_BUNDLE_ID" ]]
[[ "$ACTUAL_VERSION" == "$EXPECTED_VERSION" ]]
[[ "$ACTUAL_BUILD" == "$EXPECTED_BUILD" ]]
[[ "$ACTUAL_MINIMUM_OS" == "$EXPECTED_MINIMUM_OS" ]]
[[ "$ACTUAL_ENCRYPTION" == "false" ]]
[[ "$(plutil -extract UIDeviceFamily.0 raw "$INFO_PLIST")" == "1" ]]
[[ "$(plutil -extract UIDeviceFamily.1 raw "$INFO_PLIST")" == "2" ]]

plutil -p "$INFO_PLIST" >"$REPORTS/archive-info-plist.txt"
plutil -p "$PRIVACY_MANIFEST" >"$REPORTS/archive-privacy-manifest.txt"
find "$APP_PATH" -type f | sort >"$REPORTS/archive-files.txt"

if ! find "$APP_PATH" -type f -iname 'AppIcon*.png' -print -quit | grep -q .; then
  echo "No compiled AppIcon PNG was found in the archived application." >&2
  exit 1
fi

if find "$APP_PATH" -type f \
  \( -iname '*.mp3' -o -iname '*.m4a' -o -iname '*.wav' -o \
     -iname '*.caf' -o -iname '*.aac' \) -print -quit | grep -q .; then
  echo "A provisional audio file was bundled in the archive." >&2
  exit 1
fi

python3 - "$PRAYERS_JSON" >"$REPORTS/archive-prayer-catalog.txt" <<'PY'
import json
import sys

with open(sys.argv[1], encoding="utf-8") as handle:
    prayers = json.load(handle)
if not prayers:
    raise SystemExit("Bundled prayer catalog is empty.")
audio = [item.get("id", "<missing-id>") for item in prayers if item.get("audioAssetName") is not None]
if audio:
    raise SystemExit("Bundled catalog contains audio references: " + ", ".join(audio))
print(f"prayer_count={len(prayers)}")
print("non_null_audio_references=0")
PY

EXECUTABLE_NAME="$(plutil -extract CFBundleExecutable raw "$INFO_PLIST")"
APP_BINARY="$APP_PATH/$EXECUTABLE_NAME"
file "$APP_BINARY" | tee "$REPORTS/archive-binary-file.txt"
grep -q 'arm64' "$REPORTS/archive-binary-file.txt"
otool -L "$APP_BINARY" | tee "$REPORTS/archive-binary-dependencies.txt"
if awk 'NR > 1 {print $1}' "$REPORTS/archive-binary-dependencies.txt" |
  grep -Ev '^(/System/Library/|/usr/lib/)' | grep -q .; then
  echo "Archived binary has a non-system dynamic dependency." >&2
  exit 1
fi

{
  echo "candidate_sha=$ACTUAL_SHA"
  echo "large_iphone=$LARGE_NAME ($LARGE_UDID)"
  echo "compact_iphone=$COMPACT_NAME ($COMPACT_UDID)"
  echo "ipad=$IPAD_NAME ($IPAD_UDID)"
  echo "bundle_id=$ACTUAL_BUNDLE_ID"
  echo "version=$ACTUAL_VERSION"
  echo "build=$ACTUAL_BUILD"
  echo "minimum_os=$ACTUAL_MINIMUM_OS"
  echo "non_exempt_encryption=$ACTUAL_ENCRYPTION"
  echo "bundled_provisional_audio=0"
  echo "completed_at_utc=$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo "result=PASS_UNSIGNED_ENGINEERING_GATE"
} | tee "$REPORTS/summary.txt"

echo "Release-gate evidence: $REPORTS"
