#!/usr/bin/env bash
set -euo pipefail

if [ ! -f .env ]; then
  echo "No .env file found. Run ./setup.sh first." >&2
  exit 1
fi

# shellcheck disable=SC1091
source .env

port="${PORT:-5432}"
host="${HOST:-localhost}"

echo "postgresql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@${host}:${port}/${POSTGRES_DB}"
