#!/usr/bin/env bash
set -euo pipefail

# ── defaults ──────────────────────────────────────────────────────────
default_user="postgres"
default_db="postgres"
default_port="5432"
default_password=$(openssl rand -hex 12)

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

# ── write .env ────────────────────────────────────────────────────────
cat > .env <<EOF
POSTGRES_USER=$POSTGRES_USER
POSTGRES_PASSWORD=$POSTGRES_PASSWORD
POSTGRES_DB=$POSTGRES_DB
PORT=$PORT
EOF

echo ""
echo "Created .env — ready to run: docker compose up -d"
echo ""
echo "Connection string:"
"$(dirname "$0")"/connection-string.sh "$PORT"
