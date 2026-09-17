#!/usr/bin/env bash
# ============================================================
# 🩺 saude-sistema-executor.sh — Coleta saúde do sistema
# ============================================================
# @author: Bruno César Medeiros Siqueira
# @version: v1.2.0 (2026-09-08)
# @description: Coleta métricas: memória, disco, Ollama, OpenCode, carga
# @changelog:
#   - v1.2.0 (2026-09-08): Adiciona shebang completo e headers
#   - v1.1.0 (2026-08-20): Versão inicial (Fase 1)
# @usage:
#   ./saude-sistema-executor.sh
# @security:
#   - Usa variáveis de ambiente (COFRE_DIR, LOG_DIR)
#   - Valida existência de COFRE_DIR
#   - Registra log em pasta própria (logs/)
# ============================================================
set -euo pipefail

COFRE_DIR="${COFRE_DIR:-$HOME/archimedes-v2}"
LOG_DIR="$COFRE_DIR/docs/cerebrum/logs"
STAMP="$(date +%Y-%m-%d_%H%M%S)"
LOG_FILE="$LOG_DIR/saude-sistema-$STAMP.log"

DISK_LIMIT=90 # % de uso do disco raiz para alerta

log() { echo "$*" | tee -a "$LOG_FILE"; }

mkdir -p "$LOG_DIR"
log "===== 🩺 Saúde do sistema — $STAMP ====="

# ── 1. Memória ────────────────────────────────────────────────
log "⏳ [1/5] Memória (RAM)..."
free -h | tee -a "$LOG_FILE"

# ── 2. Disco ──────────────────────────────────────────────────
# Usa /var em vez de / para evitar falso positivo do composefs
# (overlay do Fedora Atomic/Silverblue que mostra 100% em /)
log "⏳ [2/5] Disco (ponto real: /var)..."
df -h /var | tee -a "$LOG_FILE"
USO_DISCO="$(df /var | awk 'NR==2 {gsub("%","",$5); print $5}')"
if [ "${USO_DISCO:-0}" -ge "$DISK_LIMIT" ]; then
  log "⚠️  Disco acima de ${DISK_LIMIT}% (atual: ${USO_DISCO}%) — avaliar limpeza"
else
  log "✅ Disco em ${USO_DISCO}% (limite ${DISK_LIMIT}%)"
fi

# ── 3. Ollama ─────────────────────────────────────────────────
log "⏳ [3/5] Ollama (IA local)..."
if pgrep -x ollama >/dev/null 2>&1; then
  log "✅ Processo ollama ativo"
  if command -v ollama >/dev/null 2>&1; then
    ollama ps 2>&1 | tee -a "$LOG_FILE" || true
  fi
else
  log "⚠️  Ollama NÃO está rodando"
fi

# ── 4. OpenCode ───────────────────────────────────────────────
log "⏳ [4/5] OpenCode..."
if pgrep -f opencode >/dev/null 2>&1; then
  log "✅ Processo opencode ativo"
else
  log "ℹ️  opencode não está rodando (normal — sob demanda)"
fi

# ── 5. Carga do sistema ───────────────────────────────────────
log "⏳ [5/5] Carga do sistema (uptime)..."
uptime | tee -a "$LOG_FILE"

# ── Encerramento ──────────────────────────────────────────────
log "===== 🎯 Saúde do sistema coletada — revisar log ====="
echo "📋 Log: $LOG_FILE"
