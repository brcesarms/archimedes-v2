#!/bin/bash
# ==============================================================================
# 🔄 backup.sh — Backup com Restic no Archimedes
# ==============================================================================
# Cria snapshot atômico e deduplicado do cofre usando Restic (padrão de
# indústria). Exige: restic, `~/.config/restic/password` e `.resticignore`.
#
# Uso:
#   ./scripts/backup.sh                    # Snapshot padrão (tag archimedes)
#   RESTIC_REPOSITORY=/tmp/teste ./scripts/backup.sh   # Repo alternativo
# ==============================================================================
set -euo pipefail

REPO_DIR="${RESTIC_REPOSITORY:-$HOME/backups/restic-vault}"
PASS_FILE="${RESTIC_PASSWORD_FILE:-$HOME/.config/restic/password}"
TARGET_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RESTICIGNORE="${TARGET_DIR}/.resticignore"

# 🛡️ Garante limpeza no log mesmo em falha
cleanup() {
  local rc=$?
  if [[ $rc -ne 0 ]]; then
    echo "❌ Backup falhou (exit=$rc). Verifique as mensagens acima." >&2
  fi
  exit "$rc"
}
trap cleanup EXIT

# 🧪 1/2: Pré-requisitos
echo "==> 🔍 [1/2] Verificando pré-requisitos..."
if ! command -v restic &>/dev/null; then
  echo "❌ [1/2] restic não encontrado. Execute: brew install restic" >&2
  exit 1
fi
if [[ ! -f "$PASS_FILE" ]]; then
  echo "❌ [1/2] Arquivo de senha não encontrado: $PASS_FILE" >&2
  echo "   Dica: crie com: openssl rand -hex 32 > \"$PASS_FILE\" && chmod 600 \"$PASS_FILE\"" >&2
  exit 1
fi
if [[ ! -f "$RESTICIGNORE" ]]; then
  echo "❌ [1/2] Arquivo de exclusões não encontrado: $RESTICIGNORE" >&2
  echo "   Dica: copie o modelo do cofre: cp .gitignore .resticignore" >&2
  exit 1
fi
# Repositório inicializado? Se não, instrui a inicialização.
if ! restic snapshots --repo "$REPO_DIR" --password-file "$PASS_FILE" >/dev/null 2>&1; then
  echo "❌ [1/2] Repositório restic não inicializado: $REPO_DIR" >&2
  echo "   Dica: restic init --repo \"$REPO_DIR\" --password-file \"$PASS_FILE\"" >&2
  exit 1
fi
echo "==> ✅ [1/2] Pré-requisitos OK (repo: $REPO_DIR)"

# 📸 2/2: Snapshot
echo "==> 🚀 [2/2] Criando snapshot deduplicado do cofre..."
restic backup "$TARGET_DIR" \
  --repo "$REPO_DIR" \
  --password-file "$PASS_FILE" \
  --exclude-file "$RESTICIGNORE" \
  --tag "archimedes"

echo "==> ✅ [2/2] Snapshot concluído e deduplicado com sucesso!"
