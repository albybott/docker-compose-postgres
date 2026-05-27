#!/usr/bin/env bash
set -euo pipefail

# ── defaults ──────────────────────────────────────────────────────────
folder_name=$(basename "$PWD")
default_user="$folder_name"
default_db="$folder_name"
default_email="albybott@gmail.com"
default_password=$(LC_ALL=C tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 24)

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

# ── write .env ────────────────────────────────────────────────────────
cat > .env <<EOF
POSTGRES_USER=$POSTGRES_USER
POSTGRES_PASSWORD=$POSTGRES_PASSWORD
POSTGRES_DB=$POSTGRES_DB
EOF

echo ""
echo "Created .env — ready to run: docker compose up -d"
