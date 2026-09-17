#!/usr/bin/env bash
# ============================================================
# 🩺 valida-cofre.sh — Validação completa do Obsidian Cofre
# ============================================================
# @author: Archimedes
# @version: v1.0.0 (2026-09-08)
# @description: Valida docs, scripts, links e saúde do sistema
# @usage: ./valida-cofre.sh
# @security:
#   - Usa variáveis de ambiente (COFRE_DIR)
#   - Valida caminhos antes de operações
#   - NÃO expõe senhas em logs
# ============================================================
set -euo pipefail

COFRE_DIR="${COFRE_DIR:-$HOME/archimedes-v2}"
LOG_DIR="$COFRE_DIR/docs/cerebrum/logs"
STAMP="$(date +%Y-%m-%d_%H%M%S)"
LOG_FILE="$LOG_DIR/validacao-cofre-$STAMP.log"

log() { echo "$*" | tee -a "$LOG_FILE"; }

mkdir -p "$LOG_DIR"
log "===== 🩺 Validação do Cofre — $STAMP ====="

# ── 1. Validar docs essenciais ─────────────────────────────────
log "⏳ [1/7] Validando docs essenciais..."
DOCS_ESSENCIAIS=(
  "$COFRE_DIR/docs/guia-ia-local/DEPENDENCIAS.md"
  "$COFRE_DIR/docs/guia-ia-local/IA-RESTORE.md"
  "$COFRE_DIR/docs/guia-ia-local/README-manual.md"
  "$COFRE_DIR/docs/cerebrum/README.md"
)

MISSING_DOCS=0
for doc in "${DOCS_ESSENCIAIS[@]}"; do
  if [ -f "$doc" ]; then
    log "✅ Doc presente: $(basename "$doc")"
  else
    log "❌ Doc FALTANDO: $(basename "$doc")"
    MISSING_DOCS=$((MISSING_DOCS + 1))
  fi
done

# ── 2. Validar perfis por máquina ──────────────────────────────
log "⏳ [2/7] Validando perfis por máquina..."
PERFIS_DIR="$COFRE_DIR/docs/perfis"
PERFIS_ESSENCIAIS=(
  "$PERFIS_DIR/alienware.md"
  "$PERFIS_DIR/geekom.md"
  "$PERFIS_DIR/acer-paula.md"
  "$PERFIS_DIR/README.md"
)

MISSING_PERFIS=0
for perfil in "${PERFIS_ESSENCIAIS[@]}"; do
  if [ -f "$perfil" ]; then
    log "✅ Perfil presente: $(basename "$perfil")"
  else
    log "❌ Perfil FALTANDO: $(basename "$perfil")"
    MISSING_PERFIS=$((MISSING_PERFIS + 1))
  fi
done

# ── 3. Validar scripts executáveis ─────────────────────────────
log "⏳ [3/7] Validando scripts executáveis..."
SCRIPTS_DIR="$COFRE_DIR/scripts/linux"
SCRIPTS_ESSENCIAIS=(
  "backup-cofre.sh"
  "saude-sistema-executor.sh"
  "sync-cofre.sh"
  "logs-rotator.sh"
)

MISSING_SCRIPTS=0
for script in "${SCRIPTS_ESSENCIAIS[@]}"; do
  filepath="$SCRIPTS_DIR/$script"
  if [ -f "$filepath" ]; then
    if [ -x "$filepath" ]; then
      log "✅ Script executável: $script"
    else
      log "⚠️  Script NÃO executável: $script (corrigindo...)"
      chmod +x "$filepath"
      if [ $? -eq 0 ]; then
        log "✅ Corrigido: $script"
      else
        log "❌ Erro ao corrigir: $script"
        MISSING_SCRIPTS=$((MISSING_SCRIPTS + 1))
      fi
    fi
  else
    log "❌ Script FALTANDO: $script"
    MISSING_SCRIPTS=$((MISSING_SCRIPTS + 1))
  fi
done

# ── 4. Validar runbooks ───────────────────────────────────────
log "⏳ [4/7] Validando runbooks..."
ROTINAS_DIR="$COFRE_DIR/docs/runbooks"
RUNBOOKS_ESSENCIAIS=(
  "runbook-backup-limpeza.md"
  "runbook-git-sync.md"
  "runbook-auditoria-cofre.md"
  "runbook-backup-semanal.md"
  "runbook-saude-sistema.md"
  "runbook-delegacao.md"
  "runbook-monitoramento.md"
)

MISSING_RUNBOOKS=0
for rb in "${RUNBOOKS_ESSENCIAIS[@]}"; do
  if [ -f "$ROTINAS_DIR/$rb" ]; then
    log "✅ Runbook presente: $rb"
  else
    log "❌ Runbook FALTANDO: $rb"
    MISSING_RUNBOOKS=$((MISSING_RUNBOOKS + 1))
  fi
done

# ── 5. Validar logs recentes ───────────────────────────────────
log "⏳ [5/7] Validando logs recentes..."
if [ -d "$LOG_DIR" ]; then
  LOGS_RECENTES="$(find "$LOG_DIR" -name "*.log" -mtime -1 2>/dev/null | wc -l)"
  log "ℹ️  Logs dos últimos 2 dias: $LOGS_RECENTES"
else
  log "⚠️  Diretório de logs não encontrado: $LOG_DIR"
fi

# ── 6. Validar Ollama ─────────────────────────────────────────
log "⏳ [6/7] Validando Ollama..."
if command -v ollama >/dev/null 2>&1; then
  if pgrep -x ollama >/dev/null 2>&1; then
    log "✅ Ollama rodando"
    MODELS="$(ollama list 2>/dev/null | tail -n +2 | wc -l)"
    log "ℹ️  Modelos instalados: $MODELS"
  else
    log "⚠️  Ollama NÃO está rodando"
  fi
else
  log "⚠️  Ollama não instalado"
fi

# ── 7. Validar OpenCode ───────────────────────────────────────
log "⏳ [7/7] Validando OpenCode..."
if command -v opencode >/dev/null 2>&1; then
  log "✅ OpenCode instalado"
  if pgrep -f opencode >/dev/null 2>&1; then
    log "ℹ️  OpenCode rodando"
  else
    log "ℹ️  OpenCode não está rodando (normal — sob demanda)"
  fi
else
  log "⚠️  OpenCode não instalado"
fi

# ── Encerramento ───────────────────────────────────────────────
log "===== 📊 Resumo da Validação ====="
log "Docs essenciais faltando: $MISSING_DOCS"
log "Perfis faltando: $MISSING_PERFIS"
log "Scripts faltando/não-executáveis: $MISSING_SCRIPTS"
log "Runbooks faltando: $MISSING_RUNBOOKS"
log "===== 🎯 Validação concluída ====="

# Feedback
TOTAL_MISSING=$((MISSING_DOCS + MISSING_PERFIS + MISSING_SCRIPTS + MISSING_RUNBOOKS))
if [ "$TOTAL_MISSING" -eq 0 ]; then
  echo "✅ Validação concluída: Tudo OK!"
  exit 0
else
  echo "❌ Validação concluída: $TOTAL_MISSING item(s) faltando."
  echo "Recomendado: Executar ./install.sh para completar."
  exit 1
fi
