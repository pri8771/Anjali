#!/usr/bin/env bash
set -euo pipefail

# Anjali local build & test validation harness.
# Run from anywhere: ./Scripts/build.sh
# Override the simulator with:
# DESTINATION="platform=iOS Simulator,id=<device-udid>" ./Scripts/build.sh

cd "$(dirname "$0")/.."

PROJECT="Anjali/Anjali.xcodeproj"
SCHEME="Anjali"
DESTINATION="${DESTINATION:-}"
REPORTS="BuildReports"
BUILD_LOG="$REPORTS/build.log"
TEST_LOG="$REPORTS/test.log"

mkdir -p "$REPORTS"

if [[ -z "$DESTINATION" ]]; then
  DEVICE_ID="$(
    xcrun simctl list devices available -j |
      python3 -c '
import json, sys
devices = json.load(sys.stdin).get("devices", {})
for runtime in reversed(list(devices.values())):
    for device in runtime:
        if device.get("isAvailable") and device.get("name", "").startswith("iPhone"):
            print(device["udid"])
            raise SystemExit(0)
raise SystemExit("No available iPhone simulator found.")
'
  )"
  DESTINATION="platform=iOS Simulator,id=$DEVICE_ID"
fi

echo "=== Environment ==="
date
if command -v sw_vers >/dev/null 2>&1; then
  sw_vers
else
  echo "sw_vers not available (not macOS?) — xcodebuild steps will not run here."
fi
if command -v xcodebuild >/dev/null 2>&1; then
  xcodebuild -version
else
  echo "xcodebuild not found — install Xcode 16+ and run this on macOS."
fi
echo "Destination: $DESTINATION"
echo ""

echo "=== Content validation ==="
python3 Scripts/validate_prayers.py
echo ""

echo "=== Project targets/schemes ==="
xcodebuild -list -project "$PROJECT"
echo ""

echo "=== Release build (full log -> $BUILD_LOG) ==="
set -o pipefail
xcodebuild -project "$PROJECT" -scheme "$SCHEME" \
  -configuration Release -destination "$DESTINATION" clean build 2>&1 | tee "$BUILD_LOG"
echo ""

echo "=== Test (full log -> $TEST_LOG) ==="
set -o pipefail
xcodebuild -project "$PROJECT" -scheme "$SCHEME" \
  -destination "$DESTINATION" test 2>&1 | tee "$TEST_LOG"
echo ""

echo "=== Success ==="
echo "Build and tests completed. Logs: $BUILD_LOG, $TEST_LOG"
