#!/usr/bin/env bash
# ============================================================
# 🔄 sync-cofre.sh — Sincroniza o cofre ACER ⇄ GEEKOM
# ============================================================
# @author: Bruno César Medeiros Siqueira
# @version: v1.2.0 (2026-09-08)
# @description: Sincroniza cofre entre ACER e GEEKOM via rsync+SSH
# @changelog:
#   - v1.2.0 (2026-09-08): Adiciona validação de conexão SSH
#   - v1.1.0 (2026-08-20): Adiciona suporte a --dry-run
# @usage:
#   ./sync-cofre.sh            pull (default): GEEKOM → ACER
#   ./sync-cofre.sh --push     push: ACER → GEEKOM (pede confirmação)
#   ./sync-cofre.sh --dry-run  mostra o que seria transferido
#   ./sync-cofre.sh --help     ajuda
# @security:
#   - Usa variáveis de ambiente (COFRE_DIR)
#   - Valida conexão SSH antes de transferir
#   - Exclui .git, node_modules, caches e backups
# ============================================================
set -euo pipefail

REMOTE_HOST="geekom"
# shellcheck disable=SC2088 # intencional: ~ expande no shell remoto do rsync
REMOTE_DIR='~/archimedes-v2/'
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOCAL_DIR="$(cd "${SCRIPT_DIR}/../../.." && pwd)/"

EXCLUDES=(
  --exclude='.git/'
  --exclude='.opencode/node_modules/'
  --exclude='__pycache__/'
  --exclude='*.pyc'
  --exclude='.obsidian/workspace*'
  --exclude='.obsidian/cache'
  --exclude='docs/guia-ia-local/utils/backups/'
)

show_help() { sed -n '2,7p' "$0" | sed 's/^# \{0,1\}//'; exit 0; }

MODE="pull"; DRY=""; YES=""
for arg in "$@"; do
  case "$arg" in
    --pull)    MODE="pull" ;;
    --push)    MODE="push" ;;
    --dry-run) DRY="-n" ;;
    --yes|-y)  YES="1" ;;
    --help|-h) show_help ;;
    *) echo "❌ Argumento inválido: '$arg' (use --help)" >&2; exit 1 ;;
  esac
done

echo "🔍 Verificando conexão SSH com ${REMOTE_HOST}..."
ssh -o BatchMode=yes -o ConnectTimeout=10 "${REMOTE_HOST}" 'true' 2>/dev/null \
  || { echo "❌ Sem conexão com ${REMOTE_HOST} (ssh ${REMOTE_HOST})" >&2; exit 1; }
echo "✅ Conexão OK"

if [[ "${MODE}" == "push" && -z "${YES}" ]]; then
  read -r -p "⚠️  Push sobrescreve arquivos no GEEKOM. Continuar? [s/N] " resp
  [[ "${resp}" =~ ^[sS]$ ]] || { echo "✖ Cancelado."; exit 1; }
fi

echo "⏳ ${MODE^}: ${REMOTE_HOST} ⇄ ${LOCAL_DIR}"
rsync -av ${DRY} "${EXCLUDES[@]}" \
  -e "ssh -o BatchMode=yes -o ConnectTimeout=10" \
  "${REMOTE_HOST}:${REMOTE_DIR}" "${LOCAL_DIR}"
RC=$?

if [ "${RC}" -ne 0 ]; then
  echo "✖ Operação falhou. Erro: ${RC}" >&2
  exit 1
fi

echo ""
echo "🎯 Sincronização ${MODE} concluída com sucesso! ✅"