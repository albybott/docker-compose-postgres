#!/usr/bin/env bash
set -euo pipefail

# ── load existing values ──────────────────────────────────────────────
if [ -f .env ]; then
  # shellcheck disable=SC1091
  source .env
fi

# ── defaults (prefer existing .env values) ────────────────────────────
detect_host() {
  # macOS
  if command -v ipconfig &>/dev/null; then
    for iface in en0 en1 en2 en3 en4 en5 en6 en7 en8 en9; do
      addr="$(ipconfig getifaddr "$iface" 2>/dev/null)" && echo "$addr" && return
    done
  fi
  # Linux
  if command -v ip &>/dev/null; then
    ip -4 addr show | grep -oP '(?<=inet )\d+(\.\d+){3}' | grep -v '^127\.' | head -1 && return
  fi
  echo "localhost"
}

default_user="${POSTGRES_USER:-postgres}"
default_db="${POSTGRES_DB:-postgres}"
random_port=$((RANDOM % 10001 + 40000))
default_port="${PORT:-$random_port}"
default_password="${POSTGRES_PASSWORD:-$(openssl rand -hex 12)}"
default_host="${HOST:-$(detect_host)}"

# ── helpers ───────────────────────────────────────────────────────────
ask() {
  local prompt="$1" default="$2"
  read -r -p "$prompt [$default]: " answer
  echo "${answer:-$default}"
}

# ── collect values ────────────────────────────────────────────────────
echo "Setting up .env for Postgres in: $PWD"
echo ""

POSTGRES_USER=$(ask "POSTGRES_USER" "$default_user")
POSTGRES_PASSWORD=$(ask "POSTGRES_PASSWORD" "$default_password")
POSTGRES_DB=$(ask "POSTGRES_DB" "$default_db")
PORT=$(ask "PORT" "$default_port")
HOST=$(ask "HOST" "$default_host")

# ── write .env ────────────────────────────────────────────────────────
cat > .env <<EOF
POSTGRES_USER=$POSTGRES_USER
POSTGRES_PASSWORD=$POSTGRES_PASSWORD
POSTGRES_DB=$POSTGRES_DB
PORT=$PORT
HOST=$HOST
EOF

echo ""
echo "Created .env — ready to run: docker compose up -d"
echo ""
echo "Connection string:"
"$(dirname "$0")"/connection-string.sh
