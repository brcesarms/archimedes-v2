#!/usr/bin/env bash
# ============================================================
# 🔒 verificar-seguranca.sh — Validação de segurança do cofre
# ============================================================
# @author: Archimedes
# @version: v1.0.1 (2026-09-08)
# @description: Valida scripts em busca de problemas de segurança
# @changelog:
#   - v1.0.1 (2026-09-08): Corrige false positive + ajusta range leitura
#   - v1.0.0 (2026-09-08): Versão inicial
# @usage: ./verificar-seguranca.sh
# @security:
#   - Valida scripts em busca de credenciais expostas
#   - Verifica uso de rm -rf em caminhos absolutos
#   - Valida uso de set -euo pipefail
# ============================================================
set -euo pipefail

COFRE_DIR="${COFRE_DIR:-$HOME/archimedes-v2}"
SCRIPTS_DIR="$COFRE_DIR/scripts"

log() { echo "$*"; }

log "===== 🔒 Verificação de Segurança do Cofre ====="
log ""

# ── 1. Verificar credenciais em scripts ─────────────────────────
log "⏳ [1/5] Verificando credenciais em scripts..."
CREDENCIAIS_ENCONTRADAS=0

for file in "$SCRIPTS_DIR"/**/*.sh "$SCRIPTS_DIR"/**/*.ps1; do
  [ -f "$file" ] || continue

  # Ignorar este próprio script (que contém o texto de teste)
  [ "$file" = "$COFRE_DIR/scripts/linux/verificar-seguranca.sh" ] && continue

  # Procurar por padrões sensíveis (case-insensitive)
  if grep -iEq "(password|passwd|secret|token|api_key|private_key).*=.*['\"].*['\"]" "$file" 2>/dev/null; then
    log "❌ CREDENCIAL POTENCIAL: $file"
    CREDENCIAIS_ENCONTRADAS=$((CREDENCIAIS_ENCONTRADAS + 1))
  fi
done

if [ "$CREDENCIAIS_ENCONTRADAS" -eq 0 ]; then
  log "✅ Nenhuma credência exposta encontrada"
else
  log "⚠️  ATENÇÃO: $CREDENCIAIS_ENCONTRADAS arquivo(s) com possível exposição de credenciais"
fi

# ── 2. Verificar rm -rf em caminhos absolutos ──────────────────
log ""
log "⏳ [2/5] Verificando rm -rf em caminhos absolutos..."
RISKY_RM=0

for file in "$SCRIPTS_DIR"/**/*.sh; do
  [ -f "$file" ] || continue

  # Verificar rm -rf seguido de caminho absoluto (começando com /)
  if grep -qE "rm\s+-rf\s+/" "$file" 2>/dev/null; then
    log "⚠️  RISCO POTENCIAL: $file (usa rm -rf em caminho absoluto)"
    RISKY_RM=$((RISKY_RM + 1))
  fi
done

if [ "$RISKY_RM" -eq 0 ]; then
  log "✅ Nenhum rm -rf com caminho absoluto encontrado"
else
  log "⚠️  ATENÇÃO: $RISKY_RM arquivo(s) com potencial perigo"
fi

# ── 3. Verificar uso de set -euo pipefail ───────────────────────
log ""
log "⏳ [3/5] Verificando uso de set -euo pipefail..."
MISSING_SET=0

for file in "$SCRIPTS_DIR"/**/*.sh; do
  [ -f "$file" ] || continue

  # Verificar se o arquivo tem set -euo pipefail nos primeiros 1000 caracteres (ou até 30 linhas)
  FIRST_1000="$(head -c 1000 "$file")"
  if ! echo "$FIRST_1000" | grep -q "set -euo pipefail"; then
    log "⚠️  FALTA 'set -euo pipefail': $file"
    MISSING_SET=$((MISSING_SET + 1))
  fi
done

if [ "$MISSING_SET" -eq 0 ]; then
  log "✅ Todos os scripts têm 'set -euo pipefail'"
else
  log "⚠️  ATENÇÃO: $MISSING_SET arquivo(s) sem 'set -euo pipefail'"
fi

# ── 4. Verificar headers de scripts ─────────────────────────────
log ""
log "⏳ [4/5] Verificando headers de scripts..."
MISSING_HEADERS=0

for file in "$SCRIPTS_DIR"/**/*.sh; do
  [ -f "$file" ] || continue

  # Verificar se o arquivo tem @author e @version no header
  if ! grep -q "@author:" "$file" 2>/dev/null; then
    log "⚠️  FALTA '@author': $file"
    MISSING_HEADERS=$((MISSING_HEADERS + 1))
  elif ! grep -q "@version:" "$file" 2>/dev/null; then
    log "⚠️  FALTA '@version': $file"
    MISSING_HEADERS=$((MISSING_HEADERS + 1))
  fi
done

if [ "$MISSING_HEADERS" -eq 0 ]; then
  log "✅ Todos os scripts têm headers completos"
else
  log "⚠️  ATENÇÃO: $MISSING_HEADERS arquivo(s) com headers incompletos"
fi

# ── 5. Verificar arquivos .env e *.key ──────────────────────────
log ""
log "⏳ [5/5] Verificando arquivos sensíveis (.env, *.key, *.pem)..."
SENSITIVE_FILES=0

for file in "$COFRE_DIR"/*.env "$COFRE_DIR"/**/*.env "$COFRE_DIR"/**/*.key "$COFRE_DIR"/**/*.pem "$COFRE_DIR"/**/id_rsa; do
  [ -f "$file" ] || continue
  log "❌ ARQUIVO SENSÍVEL ENCONTRADO: $file"
  SENSITIVE_FILES=$((SENSITIVE_FILES + 1))
done

if [ "$SENSITIVE_FILES" -eq 0 ]; then
  log "✅ Nenhum arquivo sensível (.env, *.key, *.pem, id_rsa) encontrado"
else
  log "❌ CRÍTICO: $SENSITIVE_FILES arquivo(s) sensível(is) encontrado(s)"
fi

# ── Encerramento ───────────────────────────────────────────────
log ""
log "===== 📊 Resumo da Verificação de Segurança ====="
log "Credenciais expostas: $CREDENCIAIS_ENCONTRADAS"
log "rm -rf com caminho absoluto: $RISKY_RM"
log "Scripts sem 'set -euo pipefail': $MISSING_SET"
log "Scripts sem headers completos: $MISSING_HEADERS"
log "Arquivos sensíveis (.env, *.key, etc.): $SENSITIVE_FILES"

TOTAL_PROBLEMAS=$((CREDENCIAIS_ENCONTRADAS + RISKY_RM + MISSING_SET + MISSING_HEADERS + SENSITIVE_FILES))

if [ "$TOTAL_PROBLEMAS" -eq 0 ]; then
  log ""
  log "✅ Verificação concluída: Tudo OK!"
  exit 0
else
  log ""
  log "⚠️  Verificação concluída: $TOTAL_PROBLEMAS problema(s) encontrado(s)"
  log "Recomendado: Revisar e corrigir os itens acima."
  exit 1
fi
