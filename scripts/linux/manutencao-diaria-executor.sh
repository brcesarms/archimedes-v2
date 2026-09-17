#!/usr/bin/env bash
# ============================================================
# 🧹 manutencao-diaria-executor.sh — Backup + limpeza de temporários
# ============================================================
# @author: Bruno César Medeiros Siqueira
# @version: v1.1.0 (2026-09-08)
# @description: Backup offline + limpeza de caches temporários (executado pelo Executor)
# @changelog:
#   - v1.1.0 (2026-09-08): Adiciona shebang completo e headers
#   - v1.0.0 (2026-08-20): Versão inicial (Fase 1)
# @usage:
#   ./manutencao-diaria-executor.sh
# @security:
#   - Usa variáveis de ambiente (COFRE_DIR, LOG_DIR)
#   - Valida existência de COFRE_DIR
#   - Exclui apenas __pycache__, *.pyc, caches regeneráveis
# ============================================================
set -euo pipefail

COFRE_DIR="${COFRE_DIR:-$HOME/archimedes-v2}"
LOG_DIR="$COFRE_DIR/docs/cerebrum/logs"
BACKUP_SCRIPT="$COFRE_DIR/scripts/linux/backup-cofre.sh"
STAMP="$(date +%Y-%m-%d_%H%M%S)"
LOG_FILE="$LOG_DIR/manutencao-$STAMP.log"

log() { echo "$*" | tee -a "$LOG_FILE"; }

# ── Pré-checagens ─────────────────────────────────────────────
if [ ! -d "$COFRE_DIR" ]; then
  echo "❌ ERRO: cofre não encontrado em $COFRE_DIR" >&2
  exit 1
fi
mkdir -p "$LOG_DIR"

log "===== 🧹 Manutenção diária — $STAMP ====="

# ── 1. Backup (obrigatório; falha aborta a manutenção) ───────
log "⏳ [1/4] Backup do cofre..."
if [ -x "$BACKUP_SCRIPT" ]; then
  if "$BACKUP_SCRIPT" >>"$LOG_FILE" 2>&1; then
    log "✅ Backup concluído"
  else
    log "❌ Backup FALHOU — abortando manutenção (tag #falha)"
    exit 1
  fi
else
  log "⚠️  Script de backup não encontrado: $BACKUP_SCRIPT (segue sem backup)"
fi

# ── 2. Limpeza de temporários (sempre regeneráveis) ──────────
log "⏳ [2/4] Removendo __pycache__ e *.pyc..."
find "$COFRE_DIR" -type d -name __pycache__ -prune -exec rm -rf {} + 2>/dev/null || true
find "$COFRE_DIR" -type f -name '*.pyc' -delete 2>/dev/null || true
log "✅ Limpo"

log "⏳ [3/4] Removendo caches do Obsidian (workspace/cache)..."
find "$COFRE_DIR/.obsidian" -maxdepth 1 \( -name 'workspace*' -o -name 'cache' \) -exec rm -rf {} + 2>/dev/null || true
log "✅ Limpo"

log "⏳ [4/4] Rotação: /tmp/opencode (>7d) e logs do sistema (>14d)..."
find /tmp/opencode -type f -mtime +7 -delete 2>/dev/null || true
find "$LOG_DIR" -name '*.log' -mtime +14 -delete 2>/dev/null || true
log "✅ Limpo"

# ── Encerramento ──────────────────────────────────────────────
log "===== 🎯 Manutenção diária concluída com sucesso ====="
echo "📋 Log: $LOG_FILE"
