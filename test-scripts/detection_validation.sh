#!/bin/bash

LOG="/var/log/suricata/eve.json"

echo "=== Suricata Detection Validation ==="

if [ ! -f "$LOG" ]; then
  echo "Suricata log not found!"
  exit 1
fi

echo "[1] Checking recent alerts..."
tail -n 20 $LOG | grep '"event_type":"alert"'

echo "[2] Counting alerts in last minute..."
COUNT=$(grep '"event_type":"alert"' $LOG | tail -n 50 | wc -l)
echo "Recent alerts: $COUNT"

echo "[3] Showing latest alert summary..."
tail -n 5 $LOG

echo "=== Validation Complete ==="
