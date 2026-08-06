#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="$PROJECT_DIR/.env"

if [[ ! -f "$ENV_FILE" ]]; then
  echo "Environment file not found: $ENV_FILE"
  exit 1
fi

DEVICE_ID="${DEVICE_ID:-emulator-5554}"

if [[ "$(adb -s "$DEVICE_ID" get-state 2>/dev/null)" != "device" ]]; then
  echo "Android device is unavailable: $DEVICE_ID"
  adb devices
  exit 1
fi

set -a
source "$ENV_FILE"
set +a

maestro --device ${DEVICE_ID} test \
  --config "$PROJECT_DIR/config.yaml" \
  --include-tags regression \
  --debug-output "$PROJECT_DIR/build/maestro-debug" \
  --format html \
  --output "$PROJECT_DIR/build/maestro-report.html" \
  -e APP_ID="$APP_ID" \
  -e TEST_EMAIL="$TEST_EMAIL" \
  "$PROJECT_DIR/flows"