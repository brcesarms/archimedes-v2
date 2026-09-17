#!/usr/bin/env bash
# ============================================================
# 🔍 validar-opencode-json.sh — Validação do opencode.json
# ============================================================
# @author: Archimedes
# @version: v1.0.0 (2026-09-08)
# @description: Valida estrutura, schema e integridade do opencode.json
# @usage: ./validar-opencode-json.sh [--quick|--full]
# @security:
#   - Valida JSON sintaticamente
#   - Verifica campos obrigatórios
#   - Detecta inconsistências
# ============================================================
set -euo pipefail

OPENCODE_JSON="${1:-$HOME/archimedes-v2/opencode.json}"

log() { echo "$*"; }

# ── Pré-checagens ──────────────────────────────────────────────
if [ ! -f "$OPENCODE_JSON" ]; then
    log "❌ Arquivo não encontrado: $OPENCODE_JSON"
    exit 1
fi

log "🔍 Validando: $OPENCODE_JSON"
log ""

# ── Validação JSON ─────────────────────────────────────────────
log "⏳ [1/5] Validação de sintaxe JSON..."
if python3 -m json.tool "$OPENCODE_JSON" > /dev/null 2>&1; then
    log "✅ Sintaxe JSON válida"
else
    log "❌ Erro de sintaxe no JSON"
    exit 1
fi

# ── Validação de campos obrigatórios ───────────────────────────
log ""
log "⏳ [2/5] Verificando campos obrigatórios..."
REQUIRED_FIELDS=("skills" "agent")

MISSING_FIELDS=0
for field in "${REQUIRED_FIELDS[@]}"; do
    if python3 -c "import json; data=json.load(open('$OPENCODE_JSON')); assert '$field' in data" 2>/dev/null; then
        log "✅ Campo '$field' presente"
    else
        log "❌ Campo '$field' FALTANDO"
        MISSING_FIELDS=$((MISSING_FIELDS + 1))
    fi
done

# ── Validação de modelo e provedores (Agnóstico) ───────────────
log ""
log "⏳ [3/5] Validação de modelo e provedores..."
python3 -c "
import json
data = json.load(open('$OPENCODE_JSON'))
model = data.get('model')
if model:
    print(f'   - Modelo padrão: {model}')
else:
    print('   - 🔓 Arquitetura agnóstica: modelo livre (selecionado via TUI/CLI)')
"

# ── Validação de perfis por máquina ────────────────────────────
log ""
log "⏳ [4/5] Validação de perfis..."
PERFIS_COUNT=$(python3 -c "import json; data=json.load(open('$OPENCODE_JSON')); print(len(data.get('profiles',{})))" 2>/dev/null)
if [ "$PERFIS_COUNT" -gt 0 ]; then
    log "✅ Perfis encontrados: $PERFIS_COUNT"
    python3 -c "
import json
data = json.load(open('$OPENCODE_JSON'))
for name, config in data.get('profiles', {}).items():
    print(f'   - {name}: {config.get(\"description\", \"N/A\")}')"
else
    log "ℹ️  Perfis desacoplados (configuração portátil)"
fi

# ── Validação de agentes ───────────────────────────────────────
log ""
log "⏳ [5/5] Validação de agentes..."
AGENT_COUNT=$(python3 -c "import json; data=json.load(open('$OPENCODE_JSON')); print(len(data.get('agent',{})))" 2>/dev/null)
if [ "$AGENT_COUNT" -gt 0 ]; then
    log "✅ Agentes encontrados: $AGENT_COUNT"
    python3 -c "
import json
data = json.load(open('$OPENCODE_JSON'))
for name, config in data.get('agent', {}).items():
    print(f'   - {name}: {config.get(\"description\", \"N/A\")[:60]}...')"
else
    log "❌ Nenhum agente encontrado"
fi

# ── Encerramento ───────────────────────────────────────────────
log ""
log "===== 📊 Resumo da Validação ====="
if [ "$MISSING_FIELDS" -eq 0 ]; then
    log "✅ Validação concluída: Tudo OK!"
    exit 0
else
    log "❌ Validação concluída: $MISSING_FIELDS campo(s) faltando"
    exit 1
fi
