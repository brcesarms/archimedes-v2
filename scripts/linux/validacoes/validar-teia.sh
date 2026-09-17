#!/usr/bin/env bash
# ============================================================
# 🕸️ validar-teia.sh — Validação da Teia de Conexões do Cofre
# ============================================================
# @author: Archimedes
# @version: v1.0.0 (2026-09-08)
# @description: Valida que todos os nós da teia estão conectados
# @usage: ./validar-teia.sh [--quick|--full]
# @security:
#   - Valida links entre arquivos
#   - Verifica referências cruzadas
#   - Detecta nós isolados
# ============================================================
set -euo pipefail

COFRE_DIR="${COFRE_DIR:-$HOME/archimedes-v2}"
PERFIS_DIR="$COFRE_DIR/docs/perfis"

log() { echo "$*"; }

log "===== 🕸️ Validação da Teia de Conexões ====="
log ""

# ── Nó Central (Coração da Teia) ───────────────────────────────
log "⏳ [1/6] Verificando nó central (MY-SETUP.md)..."
MY_SETUP="$COFRE_DIR/docs/guia-ia-local/MY-SETUP.md"

if [ ! -f "$MY_SETUP" ]; then
    log "❌ NÓ CENTRAL FALTANDO: $MY_SETUP"
    exit 1
fi
log "✅ Nó central presente: MY-SETUP.md"

# ── Verificar referências aos perfis ────────────────────────────
log ""
log "⏳ [2/6] Verificando referências aos perfis em MY-SETUP.md..."
PERFIS_NOS_LINKS=0
for perfil in geekom alienware acer-paula; do
    if grep -q -i "perfis/${perfil}" "$MY_SETUP"; then
        log "✅ MY-SETUP.md referencia perfis/${perfil}.md"
        PERFIS_NOS_LINKS=$((PERFIS_NOS_LINKS + 1))
    fi
done

# ── Verificar perfis conectam de volta ──────────────────────────
log ""
log "⏳ [3/6] Verificando links reversos (perfis → MY-SETUP.md)..."
PERFIS_COM_LINKS=0
for perfil in geekom alienware acer-paula; do
    arquivo="$PERFIS_DIR/${perfil}.md"
    if [ -f "$arquivo" ] && grep -q "MY-SETUP.md" "$arquivo"; then
        log "✅ perfis/${perfil}.md referencia MY-SETUP.md"
        PERFIS_COM_LINKS=$((PERFIS_COM_LINKS + 1))
    fi
done

# ── Verificar arquivos de perfil existem ───────────────────────
log ""
log "⏳ [4/6] Verificando arquivos de perfil em docs/perfis/..."
PERFIS_EXISTENTES=0
for perfil in geekom alienware acer-paula; do
    arquivo="$PERFIS_DIR/${perfil}.md"
    if [ -f "$arquivo" ]; then
        log "✅ perfis/${perfil}.md presente"
        PERFIS_EXISTENTES=$((PERFIS_EXISTENTES + 1))
    else
        log "❌ perfis/${perfil}.md FALTANDO"
    fi
done

# ── Verificar sistema Cérebro ───────────────────────────────────
log ""
log "⏳ [5/6] Verificando sistema Cérebro..."
if [ -f "$COFRE_DIR/AGENTS.md" ]; then
    log "✅ AGENTS.md presente"
else
    log "❌ AGENTS.md FALTANDO"
fi

if [ -f "$COFRE_DIR/docs/cerebrum/README.md" ]; then
    log "✅ cerebrum/README.md presente"
else
    log "❌ cerebrum/README.md FALTANDO"
fi

# ── Verificar Docs Essenciais ───────────────────────────────────
log ""
log "⏳ [6/6] Verificando Docs Essenciais..."
ESSENCIAIS=(
    "DEPENDENCIAS.md"
    "IA-RESTORE.md"
    "README-manual.md"
    "cerebrum/README.md"
)

ESSENCIAIS_PRESENTES=0
for doc in "${ESSENCIAIS[@]}"; do
    filepath="$COFRE_DIR/docs/guia-ia-local/$doc"
    if [ -f "$filepath" ]; then
        log "✅ Doc presente: $doc"
        ESSENCIAIS_PRESENTES=$((ESSENCIAIS_PRESENTES + 1))
    else
        log "❌ Doc FALTANDO: $doc"
    fi
done

# ── Encerramento ───────────────────────────────────────────────
log ""
log "===== 📊 Resumo da Validação da Teia ====="
log "Nó central (MY-SETUP.md): ✅"
log "Perfis existentes (arquivos): $PERFIS_EXISTENTES/3"
log "Perfis conectados (MY-SETUP → PERFIS): $PERFIS_NOS_LINKS/3"
log "Perfis com links reversos (PERFIS → MY-SETUP): $PERFIS_COM_LINKS/3"
log "Docs essenciais: $ESSENCIAIS_PRESENTES/4"
log ""

if [ "$PERFIS_EXISTENTES" -eq 3 ] && [ "$PERFIS_NOS_LINKS" -eq 3 ] && [ "$PERFIS_COM_LINKS" -eq 3 ] && [ "$ESSENCIAIS_PRESENTES" -eq 4 ]; then
    log "✅ Teia de Conexões 100% integrada!"
    exit 0
else
    log "⚠️  Teia incompleta - verificar links acima"
    exit 1
fi
