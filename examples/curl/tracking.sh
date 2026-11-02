#!/usr/bin/env bash
# Maersk Tracking API – cURL example
# Usage: PILOTERR_API_KEY=your-key ./tracking.sh
set -euo pipefail

curl -sS --fail-with-body -G "https://api.piloterr.com/v2/maersk/tracking" \
  -H "x-api-key: ${PILOTERR_API_KEY}" \
  --data-urlencode query=MMAU1155207
