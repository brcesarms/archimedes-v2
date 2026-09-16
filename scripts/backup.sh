#!/usr/bin/env bash
# ==============================================================================
# 🔄 backup.sh — Backup com Restic no Archimedes V2
# ==============================================================================
set -euo pipefail

REPO_DIR="${RESTIC_REPOSITORY:-$HOME/backups/restic-vault}"
PASS_FILE="${RESTIC_PASSWORD_FILE:-$HOME/.config/restic/password}"
TARGET_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if ! command -v restic &>/dev/null; then
    echo "❌ restic não encontrado. Execute: brew install restic" >&2
    exit 1
fi

echo "🔄 [Archimedes V2] Criando snapshot do repositório em $REPO_DIR..."
restic backup "$TARGET_DIR" \
    --repo "$REPO_DIR" \
    --password-file "$PASS_FILE" \
    --exclude-file "${TARGET_DIR}/.resticignore" \
    --tag "archimedes-v2"

echo "✅ Snapshot concluído e deduplicado com sucesso!"
