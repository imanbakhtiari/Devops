#!/bin/bash
set -euo pipefail

# Timestamp
echo "===== Run at: $(date '+%Y-%m-%d %H:%M:%S') ====="

# Target iperf server
IPERF_SERVER="19.13.17.19"
PORT="5201"

# Pushgateway
PUSHGATEWAY="http://127.0.0.1:9091/metrics/job/iperf_bandwidth"

echo "Running Download Test..."
DOWN_BPS=$(iperf3 -c "$IPERF_SERVER" -p "$PORT" -J 2>/dev/null | jq '.end.sum_received.bits_per_second')

echo "Running Upload Test..."
UP_BPS=$(iperf3 -c "$IPERF_SERVER" -p "$PORT" -R -J 2>/dev/null | jq '.end.sum_sent.bits_per_second')

# Convert bits/s -> Mbps (3 decimal places)
DOWNLOAD=$(awk "BEGIN {printf \"%.3f\", $DOWN_BPS/1000000}")
UPLOAD=$(awk "BEGIN {printf \"%.3f\", $UP_BPS/1000000}")

echo "Results:"
echo "Download: ${DOWNLOAD} Mbps"
echo "Upload:   ${UPLOAD} Mbps"

# Push to Pushgateway
cat <<EOF | curl -sS --data-binary @- "$PUSHGATEWAY"
iperf_download_mbps $DOWNLOAD
iperf_upload_mbps $UPLOAD
EOF

echo "Metrics sent to Pushgateway: $PUSHGATEWAY"
echo

