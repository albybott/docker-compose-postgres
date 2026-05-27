#!/usr/bin/env bash
set -euo pipefail

if [ ! -f .env ]; then
  echo "No .env file found. Run ./setup.sh first." >&2
  exit 1
fi

# shellcheck disable=SC1091
source .env

port="${PORT:-5432}"
host=""
for iface in en0 en1 en2 en3 en4 en5 en6 en7 en8 en9; do
  addr="$(ipconfig getifaddr "$iface" 2>/dev/null)" && host="$addr" && break
done
if [ -z "$host" ]; then
  echo "Could not detect local IP on any en interface. Set HOST in .env manually." >&2
  exit 1
fi

echo "postgresql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@${host}:${port}/${POSTGRES_DB}"
