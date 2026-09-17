#!/usr/bin/env bash
# ============================================================
# 💾 backup-semanal-executor.sh — Backup semanal + push GitHub
# ============================================================
# @author: Bruno César Medeiros Siqueira
# @version: v1.2.0 (2026-09-08)
# @description: Snapshot local + git fetch + push pendências
# @changelog:
#   - v1.2.0 (2026-09-08): Adiciona shebang completo e headers
#   - v1.1.0 (2026-08-30): Versão inicial (Fase 1)
# @usage:
#   ./backup-semanal-executor.sh
# @security:
#   - Usa variáveis de ambiente (COFRE_DIR, LOG_DIR, BACKUP_SCRIPT)
#   - Valida existência de COFRE_DIR e BACKUP_SCRIPT
#   - NÃO commita sozinho — apenas reporta alterações não commitadas
# ============================================================
set -euo pipefail

COFRE_DIR="${COFRE_DIR:-$HOME/archimedes-v2}"
LOG_DIR="$COFRE_DIR/docs/cerebrum/logs"
BACKUP_SCRIPT="$COFRE_DIR/scripts/linux/backup-cofre.sh"
STAMP="$(date +%Y-%m-%d_%H%M%S)"
LOG_FILE="$LOG_DIR/backup-semanal-$STAMP.log"

log() { echo "$*" | tee -a "$LOG_FILE"; }

# ── Pré-checagens ─────────────────────────────────────────────
if [ ! -d "$COFRE_DIR" ]; then
  echo "❌ ERRO: cofre não encontrado em $COFRE_DIR" >&2
  exit 1
fi
mkdir -p "$LOG_DIR"

log "===== 💾 Backup semanal — $STAMP ====="

# ── 1. Snapshot local (obrigatório; falha aborta) ─────────────
log "⏳ [1/4] Snapshot local do cofre..."
if [ -x "$BACKUP_SCRIPT" ]; then
  if "$BACKUP_SCRIPT" >>"$LOG_FILE" 2>&1; then
    log "✅ Snapshot local concluído"
  else
    log "❌ Snapshot FALHOU — abortando (tag #falha)"
    exit 1
  fi
else
  log "⚠️  Script de backup não encontrado: $BACKUP_SCRIPT (segue sem snapshot)"
fi

# ── 2. git fetch (verifica rede/divergência) ──────────────────
log "⏳ [2/4] git fetch (verificando GitHub)..."
if git -C "$COFRE_DIR" fetch --quiet; then
  log "✅ git fetch OK"
else
  log "❌ git fetch FALHOU — abortando (tag #falha)"
  exit 1
fi

# ── 3. Push de commits pendentes ──────────────────────────────
log "⏳ [3/4] Verificando commits locais não publicados..."
# shellcheck disable=SC1083 # intencional: @{u} é a abreviação de upstream do git
AHEAD="$(git -C "$COFRE_DIR" rev-list --count @{u}..HEAD 2>/dev/null || echo '?')"
if [ "$AHEAD" = "?" ]; then
  log "⚠️  Sem upstream configurado — nada a publicar"
elif [ "$AHEAD" -gt 0 ]; then
  log "⏳ Publicando $AHEAD commit(s) local(is) no GitHub..."
  if git -C "$COFRE_DIR" push --quiet; then
    log "✅ Push concluído ($AHEAD commit(s))"
  else
    log "❌ Push FALHOU — registrado (tag #falha)"
    exit 1
  fi
else
  log "✅ Nenhum commit pendente (tudo já publicado)"
fi

# ── 4. Relatório de alterações não commitadas ─────────────────
log "⏳ [4/4] Verificando working tree..."
if [ -n "$(git -C "$COFRE_DIR" status --porcelain)" ]; then
  log "⚠️  Existem alterações NÃO commitadas no cofre. Executor NÃO commita sozinho — aguardar revisão."
else
  log "✅ Working tree limpo"
fi

# ── Encerramento ──────────────────────────────────────────────
log "===== 🎯 Backup semanal concluído com sucesso ====="
echo "📋 Log: $LOG_FILE"
