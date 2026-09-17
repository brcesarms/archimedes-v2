#!/usr/bin/env bash
# ============================================================
# 🤖 delegar-executor.sh — Delega rotinas ao Executor (IA local)
# ============================================================
# @author: Bruno César Medeiros Siqueira
# @version: v1.1.0 (2026-09-08)
# @description: Roda opencode em modo headless com prompt do Executor
# @changelog:
#   - v1.1.0 (2026-09-08): Adiciona validação de opencode CLI
#   - v1.0.0 (2026-09-01): Versão inicial (Fase 3)
# @usage:
#   ./delegar-executor.sh             # rotina diária (default)
#   ./delegar-executor.sh auditoria   # auditoria semanal
#   ./delegar-executor.sh --help      # ajuda
# @security:
#   - Usa variáveis de ambiente (COFRE_DIR)
#   - Valida existência de opencode CLI
#   - Valida existência de prompt
# ============================================================
set -euo pipefail

COFRE_DIR="${COFRE_DIR:-$HOME/archimedes-v2}"
PROMPT_DIR="$COFRE_DIR/docs/cerebrum/prompts"
LOG_DIR="$COFRE_DIR/docs/cerebrum/logs"
STAMP="$(date +%Y-%m-%d_%H%M%S)"

# ── Help ─────────────────────────────────────────────────────
if [ "${1:-}" = "--help" ] || [ "${1:-}" = "-h" ]; then
    sed -n '2,10p' "$0" | sed 's/^# \{0,1\}//'
    exit 0
fi

# ── Modo ─────────────────────────────────────────────────────
MODE="${1:-diario}"
case "$MODE" in
    diario)    PROMPT="$PROMPT_DIR/prompt-executor-diario.md" ;;
    auditoria) PROMPT="$PROMPT_DIR/prompt-executor-auditoria.md" ;;
    *) echo "❌ Modo inválido: '$MODE' (use: diario | auditoria)" >&2; exit 1 ;;
esac

[ -f "$PROMPT" ] || { echo "❌ Prompt não encontrado: $PROMPT" >&2; exit 1; }
command -v opencode >/dev/null 2>&1 || { echo "❌ opencode CLI não encontrado no PATH" >&2; exit 1; }

LOG_FILE="$LOG_DIR/delegacao-$MODE-$STAMP.log"
mkdir -p "$LOG_DIR"

PROMPT_TEXT="$(cat "$PROMPT")"

echo "⏳ Delegando rotina [$MODE] ao Executor (opencode run --auto)..."
echo "📄 Prompt: $PROMPT"
echo "🪵 Log: $LOG_FILE"

# ── Executa opencode headless, logando saída ─────────────────
cd "$COFRE_DIR"
if opencode run --agent executor --auto --dir "$COFRE_DIR" "$PROMPT_TEXT" 2>&1 | tee -a "$LOG_FILE"; then
    RC="${PIPESTATUS[0]}"
    if [ "$RC" -ne 0 ]; then
        echo "❌ opencode run retornou código $RC (tag #falha em $LOG_FILE)"
        exit "$RC"
    fi
    echo ""
    echo "🎯 Delegação [$MODE] concluída com sucesso! ✅"
    echo "📋 Log: $LOG_FILE"
else
    echo "❌ opencode run falhou (tag #falha em $LOG_FILE)"
    exit 1
fi