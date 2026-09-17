#!/usr/bin/env bash
# ============================================================
# ✅ validar-prompt-executor.sh — Valida prompts do Executor
# ============================================================
# @author: Archimedes
# @version: v1.0.0 (2026-09-08)
# @description: Garante que prompts do Executor estão presentes e válidos
# @usage: ./validar-prompt-executor.sh
# @security:
#   - Valida existência de prompts
#   - Verifica estrutura básica
# ============================================================
set -euo pipefail

COFRE_DIR="${COFRE_DIR:-$HOME/archimedes-v2}"
PROMPT_DIR="$COFRE_DIR/docs/cerebrum/prompts"

log() { echo "$*"; }

log "===== ✅ Validação de Prompts do Executor ====="
log ""

# ── Verificar diretório ────────────────────────────────────────
log "⏳ [1/3] Verificando diretório de prompts..."
if [ -d "$PROMPT_DIR" ]; then
    log "✅ Diretório presente: $PROMPT_DIR"
else
    log "❌ Diretório FALTANDO: $PROMPT_DIR"
    exit 1
fi

# ── Verificar prompts obrigatórios ──────────────────────────────
log ""
log "⏳ [2/3] Verificando prompts obrigatórios..."
PROMPTS_ESSENCIAIS=("prompt-executor-diario.md" "prompt-executor-auditoria.md")
FALTANDO=0

for prompt in "${PROMPTS_ESSENCIAIS[@]}"; do
    filepath="$PROMPT_DIR/$prompt"
    if [ -f "$filepath" ]; then
        log "✅ Prompt presente: $prompt"
        
        # Verificar se tem o texto "Executor"
        if grep -q "Executor" "$filepath"; then
            log "   ✅ Contém referência a 'Executor'"
        else
            log "   ⚠️  Não contém 'Executor' (pode ser normal)"
        fi
    else
        log "❌ Prompt FALTANDO: $prompt"
        FALTANDO=$((FALTANDO + 1))
    fi
done

# ── Verificar estrutura básica ──────────────────────────────────
log ""
log "⏳ [3/3] Verificando estrutura dos prompts..."
for prompt in "${PROMPTS_ESSENCIAIS[@]}"; do
    filepath="$PROMPT_DIR/$prompt"
    [ -f "$filepath" ] || continue
    
    # Verificar se tem seções principais
    if grep -q "^# " "$filepath"; then
        log "✅ $prompt tem H1"
    else
        log "❌ $prompt NÃO tem H1"
    fi
    
    if grep -q "Executor" "$filepath"; then
        log "✅ $prompt menciona 'Executor'"
    else
        log "⚠️  $prompt não menciona 'Executor'"
    fi
done

# ── Encerramento ───────────────────────────────────────────────
log ""
log "===== 📊 Resumo da Validação ====="
if [ "$FALTANDO" -eq 0 ]; then
    log "✅ Prompts do Executor: Tudo OK!"
    log ""
    log "💡 O Executor pode começar a trabalhar!"
    exit 0
else
    log "❌ Prompts do Executor: $FALTANDO FALTANDO"
    exit 1
fi
