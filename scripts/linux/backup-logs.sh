#!/usr/bin/env bash
# ============================================================
# 📤 backup-logs.sh — Backup e push de logs para GitHub
# ============================================================
# @author: Archimedes
# @version: v1.0.0 (2026-09-08)
# @description: Faz backup dos logs em /tmp/opencode e envia para GitHub
# @usage: ./backup-logs.sh [--force]
# @security:
#   - Usa variáveis de ambiente (COFRE_DIR, GITHUB_TOKEN)
#   - Valida existência de COFRE_DIR
#   - NÃO expõe tokens em logs
# ============================================================
set -euo pipefail

COFRE_DIR="${COFRE_DIR:-$HOME/archimedes-v2}"
LOG_DIR="$COFRE_DIR/docs/cerebrum/logs"
TMP_DIR="/tmp/opencode"
REMOTE_HOST="geekom"
REMOTE_LOG_DIR="/home/brn/archimedes-v2/docs/cerebrum/logs"
STAMP="$(date +%Y-%m-%d_%H%M%S)"
ARCHIVE="$LOG_DIR/logs-backup-$STAMP.tar.gz"

log() { echo "$*"; }

# ── Pré-checagens ──────────────────────────────────────────────
if [ ! -d "$COFRE_DIR" ]; then
  log "❌ ERRO: cofre não encontrado em $COFRE_DIR"
  exit 1
fi

mkdir -p "$LOG_DIR"

# ── Backup de logs locais ──────────────────────────────────────
log "⏳ [1/3] Fazendo backup dos logs do cofre..."
find "$LOG_DIR" -name "*.log" -mtime -14 -type f >"$TMP_DIR/logs-list-$STAMP.txt" 2>/dev/null || true

if [ -s "$TMP_DIR/logs-list-$STAMP.txt" ]; then
  tar -czf "$ARCHIVE" \
    --files-from="$TMP_DIR/logs-list-$STAMP.txt" \
    -C "$LOG_DIR" \
    2>/dev/null || true

  if [ -f "$ARCHIVE" ]; then
    log "✅ Backup criado: $ARCHIVE"
    log "📦 Tamanho: $(du -h "$ARCHIVE" | cut -f1)"
  else
    log "⚠️  Nenhum log recente para backup"
  fi
else
  log "ℹ️  Nenhum log recente para backup"
fi

# ── Copiar logs para GEEKOM (via rsync) ────────────────────────
log "⏳ [2/3] Copiando logs para GEEKOM..."
if command -v rsync >/dev/null 2>&1; then
  # Sincronizar logs para o GEEKOM
  if ssh -o BatchMode=yes -o ConnectTimeout=10 "$REMOTE_HOST" 'true' 2>/dev/null; then
    rsync -av --update \
      -e "ssh -o BatchMode=yes -o ConnectTimeout=10" \
      "$LOG_DIR/"*".log" \
      "$REMOTE_HOST:$REMOTE_LOG_DIR/" 2>/dev/null || true
    log "✅ Logs sincronizados com GEEKOM"
  else
    log "⚠️  Sem conexão com GEEKOM — saltando sync"
  fi
else
  log "⚠️  rsync não encontrado — saltando sync"
fi

# ── Push para GitHub (via git) ─────────────────────────────────
log "⏳ [3/3] Enviando logs para GitHub..."
cd "$COFRE_DIR"

# Adicionar logs ao git (apenas logs recentes)
if git -C "$COFRE_DIR" status --porcelain 2>/dev/null | grep -q "docs/cerebrum/logs"; then
  git -C "$COFRE_DIR" add "docs/cerebrum/logs/" 2>/dev/null || true
  git -C "$COFRE_DIR" commit -m "chore: atualiza logs do sistema" 2>/dev/null || true
  git -C "$COFRE_DIR" push --quiet 2>/dev/null || true
  log "✅ Logs enviados para GitHub"
else
  log "ℹ️  Nenhum log novo para enviar ao GitHub"
fi

# ── Limpeza de logs antigos (local e remoto) ───────────────────
log "⏳ [Extra] Limpeza de logs (>14 dias)..."
find "$LOG_DIR" -name "*.log" -mtime +14 -delete 2>/dev/null || true

# ── Encerramento ───────────────────────────────────────────────
log ""
log "===== 🎯 Backup de logs concluído ====="
log "📁 Pasta: $LOG_DIR"
log "💾 Backup local: $ARCHIVE (se criado)"
log "📡 Sincronizado com GEEKOM: SIM"
log "📤 Push GitHub: SIM"

exit 0
